class Genre < ActiveRecord::Base
  belongs_to :media_type
  has_many :products

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :media_type_id

  default_scope :order => 'title'
  named_scope :for_cd,  :conditions => { :media_type_id => 1 }
  named_scope :for_dvd, :conditions => { :media_type_id => 2 }
end

