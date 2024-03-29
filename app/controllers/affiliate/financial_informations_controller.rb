class Affiliate::FinancialInformationsController < AffiliateController
  belongs_to :affiliate
  
  def create
    create! do |success, failure|
      success.html { redirect_to affiliate_affiliate_financial_informations_path(current_affiliate) }
    end
  end
  
  def show
    redirect_to affiliate_affiliate_financial_informations_path(current_affiliate)
  end
  
  def send_deposit
    @financial_information = FinancialInformation.find(params[:id])
    
    if ! @financial_information.send_deposit
      flash[:warning] = @financial_information.errors.full_messages
    else
      flash[:notice] = "Deposit sent. You should receive it in the following few days."
    end
    redirect_to affiliate_affiliate_financial_informations_path(current_affiliate)
  end
  
  def validate
    @financial_information = FinancialInformation.find(params[:id])
    
    if request.put?
      if ! @financial_information.validate_deposits(params[:deposit1], params[:deposit2])
        flash[:warning] = "Input deposits weren't correct."
      else
        flash[:notice] = "Financial information correctly validated."
        redirect_to affiliate_affiliate_financial_informations_path(current_affiliate)
      end
    end
  end
  
  def make_default
    @financial_information = FinancialInformation.find(params[:id])
    
    default = current_affiliate.default_financial_information
    default.default = false
    if default.save
      @financial_information.default = true
      if @financial_information.save
        flash[:notice] = "Default set."
        redirect_to affiliate_affiliate_financial_informations_path(current_affiliate)
      end
    end
  end
end

