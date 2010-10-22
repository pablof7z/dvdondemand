class Retail::OrdersController < Retail::RetailController
  before_filter :authenticate_customer!
  belongs_to :customer
end

