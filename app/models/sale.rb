class Sale < ActiveRecord::Base
  belongs_to :publisher
  has_many :payments
  has_many :fees
  has_one :order
end
