class Order < ActiveRecord::Base
  has_one :payment
end
