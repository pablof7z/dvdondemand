class Publish::WholesalePricesController < Publish::PublishController
  belongs_to :publisher, :product
end

