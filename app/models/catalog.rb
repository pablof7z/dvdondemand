class Catalog < ActiveRecord::Base
  belongs_to :publisher
  has_and_belongs_to_many :products
  has_one :facebook_catalog
  
  validates_presence_of :title, :publisher_id
  validates_uniqueness_of :title, :scope => :publisher_id, :allow_blank => true

  named_scope :public, :conditions => { :private => false }
  named_scope :private, :conditions => { :private => true }
  
  def available_for_retail_listing
    return false if publisher == nil
    return false if publisher.approved != true
    return false if products.empty?
    return false if has_a_product_available_for_retail_listing != true
    return true
  end
  
  def available_for_retail_listing?
    available_for_retail_listing == true
  end
  
  def has_a_product_available_for_retail_listing
    products.each { |p| return true if p.available_for_retail_listing? }
    return false
  end
end

