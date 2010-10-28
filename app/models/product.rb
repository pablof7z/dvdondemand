class Product < ActiveRecord::Base
  belongs_to :media_type
  belongs_to :publisher
  belongs_to :genre

  has_many :order_items
  has_many :product_flags  # customers may flag a product for provided reasons

  has_and_belongs_to_many :catalogs
  has_and_belongs_to_many :items

  validates_presence_of :media_type, :genre, :title, :description, :price

  has_attached_file :cover, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :cover, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'] # latter for IE support

  acts_as_taggable
  acts_as_taggable_on :keywords

  def cd?
    # do not check thru MediaType association to make comparison snappier
    media_type_id == MediaType::CD
  end

  def dvd?
    media_type_id == MediaType::DVD
  end
end

