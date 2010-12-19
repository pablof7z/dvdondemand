class Publish::BankInformationsController < PublishController
  belongs_to :publisher
  
  def show
    redirect_to publish_publisher_bank_informations_path(current_publisher)
  end
  
  def send_deposit
    @bank_information = BankInformation.find(params[:id])
    
    if ! @bank_information.send_deposit
      flash[:warning] = @bank_information.errors.full_messages
    else
      flash[:notice] = "Deposit sent. You should receive in the following few days."
    end
    redirect_to publish_publisher_bank_informations_path(current_publisher)
  end
  
  def validate
    @bank_information = BankInformation.find(params[:id])
    
    if request.put?
      if ! @bank_information.validate_deposits(params[:deposit1], params[:deposit2])
        flash[:warning] = "Input deposits weren't correct."
      else
        flash[:notice] = "Financial information correctly validated."
        redirect_to publish_publisher_bank_informations_path(current_publisher)
      end
    end
  end
  
  def make_default
    @bank_information = BankInformation.find(params[:id])
    
    default = current_publisher.default_bank_information
    default.default = false
    if default.save
      @bank_information.default = true
      if @bank_information.save
        flash[:notice] = "Default set."
        redirect_to publish_publisher_bank_informations_path(current_publisher)
      end
    end
  end
end

