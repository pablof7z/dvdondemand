class Admin::PaymentsController < AdminController
  belongs_to :wholesaler
  belongs_to :invoice
  
  def create
    params[:payment] = params[:wholesaler_payment]
    params[:payment][:charged] = true
    super
  end
  
  def update
    params[:payment] = params[:wholesaler_payment]
    params[:payment][:charged] = true
    super
  end
end

