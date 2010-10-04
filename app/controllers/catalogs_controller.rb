class CatalogsController < ApplicationController
  inherit_resources
  belongs_to :publisher

  layout 'publisher'
end
