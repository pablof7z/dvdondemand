class ProductsController < ApplicationController
  inherit_resources
  belongs_to :publisher do
    belongs_to:catalog, :optional => true
  end

  layout 'publisher'
end
