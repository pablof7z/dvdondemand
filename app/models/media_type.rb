class MediaType < ActiveRecord::Base
  CD  = 1
  DVD = 2

  has_many :genres
  has_many :products

  validates_presence_of :name

  default_scope :order => 'name'
end

