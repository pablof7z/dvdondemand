class Genre < ActiveRecord::Base
  has_many :products

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :media
end

