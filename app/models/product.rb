class Product < ActiveRecord::Base
  belongs_to :media_type
  belongs_to :publisher, :dependent => :destroy
  belongs_to :genre

  has_many :order_items
  has_many :product_flags  # customers may flag a product for provided reasons

  has_and_belongs_to_many :catalogs

  has_many :product_options  # product packaging options
  has_many :packaging_options, :through => :product_options

  validates_presence_of :media_type, :genre, :title, :description
  validates_numericality_of :price, :greater_than => 0

  has_attached_file :image,  :url => '/system/images/:id/:basename_:style.:extension',
                             :styles => { :cropped => { :jcrop => true },
                                         :cropped_medium => { :jcrop => true, :geometry => "210x283>" },
                                         :cropped_small => { :jcrop => true, :geometry => "90x121>" },
                                         :medium => "300x300>",
                                         :small => { :jcrop => true, :geometry => "90x121>" },
                                         :thumb => { :jcrop => true, :geometry => "35x35>" } }, :processors => [:jcropper]

  has_attached_file :cover_art, :url => '/system/:id/cover_:style.:extension',
                               :styles => { :cropped => { :jcrop => true },
                                             :cropped_medium => { :jcrop => true, :geometry => "240x240>" },
                                             :medium => "300x300>",
                                             :thumb => "100x100>" }, :processors => [:jcropper]

  has_attached_file :cd_sleeve_art, :url => '/system/:id/sleeve_:style.:extension',
                                    :styles => { :cropped => { :jcrop => true },
                                                 :cropped_medium => { :jcrop => true, :geometry => "240x240>" },
                                                 :medium => "300x300>",
                                                 :thumb => "100x100>" }, :processors => [:jcropper]

  has_attached_file :dvd_sleeve_art, :url => '/system/:id/sleeve_:style.:extension',
                                     :styles => { :cropped => { :jcrop => true },
                                                  :cropped_medium => { :jcrop => true, :geometry => "240x240>" },
                                                  :medium => "300x300>",
                                                  :thumb => "100x100>" }, :processors => [:jcropper]

  validates_attachment_content_type :cover_art,      :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :allow_nil => true # latter for IE support
  validates_attachment_content_type :cd_sleeve_art,  :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :if => :cd?, :allow_nil => true
  validates_attachment_content_type :dvd_sleeve_art, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :if => :dvd?, :allow_nil => true

  has_attached_file :iso, :url => '/system/:id/disc.iso', :storage => :appendable
  has_attached_file :audio_files, :url => '/system/:id/audio.:extension', :storage => :appendable

  acts_as_taggable
  acts_as_taggable_on :keywords

  after_update :reprocess_arts

  attr_accessor :image_crop_x, :image_crop_y, :image_crop_w, :image_crop_h
  attr_accessor :cover_art_crop_x, :cover_art_crop_y, :cover_art_crop_w, :cover_art_crop_h
  attr_accessor :cd_sleeve_art_crop_x, :cd_sleeve_art_crop_y, :cd_sleeve_art_crop_w, :cd_sleeve_art_crop_h
  attr_accessor :dvd_sleeve_art_crop_x, :dvd_sleeve_art_crop_y, :dvd_sleeve_art_crop_w, :dvd_sleeve_art_crop_h

  attr_accessor :iso_chunk, :iso_eof
  attr_accessor :audio_files_chunk, :audio_files_eof

  # please don't use default_scope to hide deleted products. See http://blog.semanticart.com/2009/03/22/using-default-scope-to-recreate-acts-as-paranoid.html
  named_scope :available, :conditions => {:deleted_at => nil}
  named_scope :available_filo, :conditions => {:deleted_at => nil}, :order => 'created_at DESC'
  named_scope :flagged, :conditions => 'flag_count is not null and flag_count > 0', :order => 'flag_count DESC'
  named_scope :featured, :conditions => 'featured is not null', :order => 'featured ASC'

  # set the pagination limit here, but mind the tests
  def self.per_page
    10  
  end

  def self.for_retail
    all.reject { |p| !p.retailable? }
  end

  def retailable?
    # this is beging to be refactored, as is "available_for_retail_listing"
    available_for_retail_listing?
  end

  def cd?
    # do not check thru MediaType association to make comparison snappier
    media_type_id == MediaType::CD
  end

  def dvd?
    media_type_id == MediaType::DVD
  end
  
  def image_thumb
    if image.exists?(:thumb)
      image.url(:thumb)
    else
      if cd?
        "cd-front-26x26.png"
      elsif dvd?
        "dvd-front-26x35.png"
      end
    end
  end

  def available?
    deleted_at == nil
  end

  def available_packaging_options
    # "standard" packaging option is always free
    standard = PackagingOption.find(:first, :conditions => {:price => 0})
    # and should be always available to all products
    packaging_options.include?(standard) ? packaging_options : [standard] + packaging_options
  end
  
  def available_for_retail_listing
    return "No publisher selected" if publisher == nil
    return "Publisher not yet approved" if publisher.approved != true
    return "Product is not associated with any catalog" if catalogs.empty?
    return "Product has no audio file" if cd? and not audio_files?
    return "Product has no ISO file" if dvd? and not iso?
    return "Product is deleted" unless available?
    return true
  end
  
  def available_for_retail_listing?
    available_for_retail_listing == true
  end

  def public_catalogs
    catalogs.select { |c| ! c.private }
  end

  def private_catalogs
    catalogs.select { |c| c.private }
  end

  def self.best_selling(limit = 5)
    find(:all, :order => 'times_sold DESC', :limit => limit).select do |product|
      product.available_for_retail_listing?
    end
  end

  def self.random(opts = {})
    opts = { :order => 'rand()', :limit => 25 }.merge(opts) #MySQL specific code
    all(opts).select { |product| product.available_for_retail_listing? }
  end
  
  def destroy
    self.update_attribute(:deleted_at, Time.now)
  end

  private

  def reprocess_arts
    [ :image, :cover_art, :cd_sleeve_art, :dvd_sleeve_art ].each do |art|
      send(art).reprocess! if
        eval("!#{art}_crop_x.blank? and !#{art}_crop_y.blank? and " +
             "!#{art}_crop_w.blank? and !#{art}_crop_h.blank?")
    end
  end
end
