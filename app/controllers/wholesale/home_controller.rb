class Wholesale::HomeController < ApplicationController
  before_filter :authenticate_wholesaler!
  layout 'wholesale'
  
  def index; end
end
