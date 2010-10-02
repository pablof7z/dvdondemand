class ProductsController < ApplicationController
  inherit_resources
  belongs_to :publisher
  layout 'publisher'
end
