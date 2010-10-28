class Genre < ActiveRecord::Base
  belongs_to :media_type
  has_many :products

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :media_type_id

  default_scope :order => 'media_type_id, title'
  named_scope :for_cd,  :conditions => { :media_type_id => MediaType::CD }
  named_scope :for_dvd, :conditions => { :media_type_id => MediaType::DVD }
end

