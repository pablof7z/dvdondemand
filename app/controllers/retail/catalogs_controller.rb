class Retail::CatalogsController < ApplicationController
  inherit_resources
  actions :index, :show

  layout 'retail'
end

