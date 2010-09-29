class Order < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :customer
  belongs_to :shipping_option
  has_many :order_items
end
