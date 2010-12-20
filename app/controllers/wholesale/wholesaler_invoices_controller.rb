class Wholesale::WholesalerInvoicesController < WholesaleController
  belongs_to :wholesaler
  
  def pay
    @wholesaler_invoice = WholesalerInvoice.find(params[:id])
    @wholesaler_payment = WholesalerPayment.new(params[:wholesaler_payment])
    @wholesaler_payment.invoice = @wholesaler_invoice
    
    redirect_to wholesale_wholesaler_wholesaler_invoices_path(current_wholesaler)
    
    if request.post?
      @wholesaler_payment.charged = false
      if @wholesaler_payment.save
        if @wholesaler_payment.purchase
          @wholesaler_payment.charged = true
          @wholesaler_payment.save
          flash[:notice] = "Charged was done"
        else
          flash[:warning] = "Unable to charge credit card"
        end
      end
    else
      @wholesaler_payment.amount = @wholesaler_invoice.owed unless params[:wholesaler_payment]
    end
  end
end

