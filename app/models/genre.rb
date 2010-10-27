class Genre < ActiveRecord::Base
  has_many :products

  default_scope :order => 'media, title'

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :media
end

