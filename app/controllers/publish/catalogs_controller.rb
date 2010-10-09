class Publish::CatalogsController < ApplicationController
  inherit_resources
  belongs_to :publisher

  layout 'publisher'
end
