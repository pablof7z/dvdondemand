class Affiliate::HomeController < ApplicationController
  before_filter :authenticate_affiliate!
  layout 'affiliate'
  
  def index; end
end
