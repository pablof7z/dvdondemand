class Product < ActiveRecord::Base
  belongs_to :publisher
  has_many :order_items
  has_and_belongs_to_many :catalogs
  has_and_belongs_to_many :items
  has_many :wholesale_prices, :dependent => :delete_all
  has_many :product_flags

  accepts_nested_attributes_for :wholesale_prices, :reject_if => lambda { |w| w[:minimum_quantity].blank? || w[:discount_percentage].blank? }

  # cover art image uploads support thanks to Paperclip gem
  has_attached_file :cover, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :cover, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'] # latter for IE support
end

