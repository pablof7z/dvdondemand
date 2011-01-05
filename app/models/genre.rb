class Genre < ActiveRecord::Base
  belongs_to :media_type
  has_many :products

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :media_type_id

  default_scope :order => 'media_type_id, title'
  named_scope :for_cd,  :conditions => { :media_type_id => MediaType::CD }
  named_scope :for_dvd, :conditions => { :media_type_id => MediaType::DVD }
  
  def available_for_retail_products
    @products = Product.all(:order => :updated_at, :limit => 5).map do |p|
      p if p.available_for_retail_listing?
    end.compact
  end
end

