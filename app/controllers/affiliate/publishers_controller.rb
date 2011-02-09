class Affiliate::PublishersController < AffiliateController
  before_filter :authenticate_affiliate!
  belongs_to :affiliate
end
