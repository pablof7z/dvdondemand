class PackagingOption < ActiveRecord::Base
  has_many :order_items

  validates_presence_of :title, :price
end

