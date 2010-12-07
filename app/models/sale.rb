class Sale < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :order
  has_many :publisher_payments
end
