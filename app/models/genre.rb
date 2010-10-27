class Genre < ActiveRecord::Base
  belongs_to :media_type
  has_many :products

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :media_type_id

  default_scope :order => 'media_type_id, title'
end

