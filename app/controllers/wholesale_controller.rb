class WholesaleController < InheritedResources::Base
  before_filter :authenticate_wholesaler!
  layout 'wholesale'
end

