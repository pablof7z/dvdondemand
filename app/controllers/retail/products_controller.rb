class Retail::ProductsController < ApplicationController
  inherit_resources
  belongs_to :catalog, :optional => true
  actions :show

  layout 'retail'
end
