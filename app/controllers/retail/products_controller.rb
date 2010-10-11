class Retail::ProductsController < ApplicationController
  inherit_resources
  belongs_to :catalog, :optional => true
  actions :show

  layout 'retail'

  def show
    show! do
      render(:text => 'Forbidden', :status => 403) and return if @catalog.private
    end
  end
end

