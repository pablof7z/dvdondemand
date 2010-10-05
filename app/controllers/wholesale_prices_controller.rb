class WholesalePricesController < ApplicationController
  inherit_resources
  belongs_to :publisher, :product

  layout 'publisher'
end

