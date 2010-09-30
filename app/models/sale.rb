class Sale < ActiveRecord::Base
  belongs_to :publisher
  has_many :publisher_payments
  has_many :fees
  has_one :order
end
