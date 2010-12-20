class Wholesale::CreditCardsController < WholesaleController
  before_filter :authenticate_wholesaler!, :except => [ :index ]
  belongs_to :wholesaler
  
  def create
    create! do |success, failure|
      success.html { redirect_to wholesale_wholesaler_credit_cards_path(current_wholesaler) }
    end
  end
  
  def make_default
    current_wholesaler.credit_cards.each { |i| i.default = false; i.save }
    
    @credit_card = CreditCardData.find(params[:id])
    @credit_card.default = true
    @credit_card.save
  end
end
