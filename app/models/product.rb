class Product < ActiveRecord::Base
  belongs_to :media_type
  belongs_to :publisher
  belongs_to :genre

  has_many :isos
  has_many :order_items
  has_many :product_flags  # customers may flag a product for provided reasons

  has_and_belongs_to_many :catalogs
  has_and_belongs_to_many :items

  has_many :product_options  # product packaging options
  has_many :packaging_options, :through => :product_options

  validates_presence_of :media_type, :genre, :title, :description
  validates_numericality_of :price, :greater_than => 0

  has_attached_file :image, :styles => { :cropped => { :jcrop => true },
                                         :cropped_medium => { :jcrop => true, :geometry => "210x283>" },
                                         :cropped_small => { :jcrop => true, :geometry => "90x121>" },
                                         :medium => "300x300>",
                                         :small => { :jcrop => true, :geometry => "90x121>" },
                                         :thumb => { :jcrop => true, :geometry => "35x35>" } }, :processors => [:jcropper]

  has_attached_file :cover_art, :styles => { :cropped => { :jcrop => true },
                                             :cropped_medium => { :jcrop => true, :geometry => "240x240>" },
                                             :medium => "300x300>",
                                             :thumb => "100x100>" }, :processors => [:jcropper]

  has_attached_file :cd_sleeve_art, :styles => { :cropped => { :jcrop => true },
                                                 :cropped_medium => { :jcrop => true, :geometry => "240x240>" },
                                                 :medium => "300x300>",
                                                 :thumb => "100x100>" }, :processors => [:jcropper]

  has_attached_file :dvd_sleeve_art, :styles => { :cropped => { :jcrop => true },
                                                  :cropped_medium => { :jcrop => true, :geometry => "240x240>" },
                                                  :medium => "300x300>",
                                                  :thumb => "100x100>" }, :processors => [:jcropper]

  validates_attachment_content_type :cover_art,      :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'] # latter for IE support
  validates_attachment_content_type :cd_sleeve_art,  :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :if => :cd? 
  validates_attachment_content_type :dvd_sleeve_art, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :if => :dvd?

  has_attached_file :iso

  acts_as_taggable
  acts_as_taggable_on :keywords

  after_update :reprocess_arts

  attr_accessor :image_crop_x, :image_crop_y, :image_crop_w, :image_crop_h
  attr_accessor :cover_art_crop_x, :cover_art_crop_y, :cover_art_crop_w, :cover_art_crop_h
  attr_accessor :cd_sleeve_art_crop_x, :cd_sleeve_art_crop_y, :cd_sleeve_art_crop_w, :cd_sleeve_art_crop_h
  attr_accessor :dvd_sleeve_art_crop_x, :dvd_sleeve_art_crop_y, :dvd_sleeve_art_crop_w, :dvd_sleeve_art_crop_h

  # please don't use default_scope to hide deleted products. See http://blog.semanticart.com/2009/03/22/using-default-scope-to-recreate-acts-as-paranoid.html
  named_scope :available, :conditions => {:deleted_at => nil}
  versioned

  def cd?
    # do not check thru MediaType association to make comparison snappier
    media_type_id == MediaType::CD
  end

  def dvd?
    media_type_id == MediaType::DVD
  end

  def available_packaging_options
    # "standard" packaging option is always free
    standard = PackagingOption.find(:first, :conditions => {:price => 0})
    # and should be always available to all products
    packaging_options.include?(standard) ? packaging_options : [standard] + packaging_options
  end
  
  def available_for_retail_listing
    return "No publisher selected" if publisher == nil
    return "Publisher not yet approved" if publisher.approved == false
    return "Product is not associated with any catalog" if catalogs.empty?
    return "Product has no ISO file" if isos.empty?
    return true
  end
  
  def available_for_retail_listing?
    available_for_retail_listing == true
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

