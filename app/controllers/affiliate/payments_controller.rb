class Affiliate::PaymentsController < AffiliateController
  belongs_to :affiliate
  
  private
  
  def collection
    @payments = Payment.find(:all, :conditions => { :owner_id => current_affiliate.id, :owner_type => 'Affiliate' }).map do |a|
      a if a.is_test_deposit? == false
    end.compact
  end
end

