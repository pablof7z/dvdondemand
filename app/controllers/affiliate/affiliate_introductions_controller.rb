class Affiliate::AffiliateIntroductionsController < AffiliateController
  before_filter :authenticate_affiliate!, :except => :use
  belongs_to :affiliate
  
  def create
    create! do |success, failure|
      success.html { flash[:notice] = "Affiliate introduction was sent"; redirect_to affiliate_affiliate_affiliate_introductions_path(current_affiliate) }
    end
  end
  
  def use
    @affiliate_introduction = AffiliateIntroduction.find_by_signup_hash(params[:id])
    
    if @affiliate_introduction == nil
      flash[:warning] = "The link you have used seems invalid, make sure you use the complete URL provided"
      redirect_to root_path and return
    end
    
    redirect_to new_publisher_registration_path(:id => params[:id])
  end
end
