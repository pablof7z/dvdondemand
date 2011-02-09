class AffiliateController < InheritedResources::Base
  before_filter :authenticate_affiliate!
  layout 'affiliate'
end

