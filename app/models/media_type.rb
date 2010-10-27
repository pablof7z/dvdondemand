class MediaType < ActiveRecord::Base
  has_many :genres
  has_many :products

  validates_presence_of :name

  default_scope :order => 'name'
end

