class Admin::BulkPaymentsController < AdminController
  before_filter :load_bulk_payment, :only => [ :ach, :paypal ]
  
  def generate
    unless request.post?
      @publishers = Sale.pending_payment_publishers
      @affiliates = Sale.pending_payment_affiliates
      @validation = FinancialInformation.waiting_approval.map { |i| i if i.deposit1.bulk_payment == nil and i.deposit2.bulk_payment == nil }.compact
    else
      if (params[:publisher] == nil or params[:publisher].empty?) and
         (params[:affiliate] == nil or params[:affiliate].empty?) and
         (params[:validation] == nil or params[:validation].empty?)
        flash[:warning] = "No accounts selected"
        redirect_to generate_admin_bulk_payment_path(1) and return
      end
      
      bulk_payment = BulkPayment.new
      bulk_payment.save!
      
      # Go through each selected publisher
      params[:publisher].each do |i|
        # Get the publisher
        publisher = Publisher.find(i)
        
        # Create the payment
        payment = Payment.new(:owner => publisher,
                              :amount => publisher.pending_payment_totals,
                              :memo => "Payment created by #{current_admin.email}",
                              :financial_information => publisher.default_financial_information,
                              :bulk_payment => bulk_payment)
        
        # Save payment
        if ! payment.save
          flash[:warning] = "Payment couldn't be created for #{publisher.full_name}"
          bulk_payment.destroy
          redirect_to generate_admin_payment_path(1) and return
        else
          publisher.sales.pending_payment_publisher.each do |sale|
            sale.payment = payment
            sale.save!
          end
          
          bulk_payment.add_payment(payment)
        end
      end if params[:publisher] != nil
      
      # Go through each selected affiliate
      params[:affiliate].each do |i|
        # Get the affiliate
        affiliate = Affiliate.find(i)
        
        # Create the payment
        payment = Payment.new(:owner => affiliate,
                              :amount => affiliate.pending_payment_totals,
                              :memo => "Payment created by #{current_admin.email}",
                              :financial_information => affiliate.default_financial_information,
                              :bulk_payment => bulk_payment)
        
        # Save payment
        if ! payment.save
          flash[:warning] = "Payment couldn't be created for #{affiliate.full_name}"
          bulk_payment.destroy
          redirect_to generate_admin_payment_path(1) and return
        else
          affiliate.sales.pending_payment_affiliate.each do |sale|
            sale.affiliate_payment = payment
            sale.save!
          end
          
          bulk_payment.add_payment(payment)
        end
      end if params[:affiliate] != nil
      
      # Go through each selected validation
      params[:validation].each do |i|
        # Get the financial information
        financial_information = FinancialInformation.find(i)
        
        # Create the payment
        financial_information.deposit1.bulk_payment = bulk_payment
        financial_information.deposit2.bulk_payment = bulk_payment
        financial_information.deposit1.save!
        financial_information.deposit2.save!
        
        bulk_payment.add_payment(financial_information.deposit1)
        bulk_payment.add_payment(financial_information.deposit2)
      end if params[:validation] != nil
      
      bulk_payment.fixate
      bulk_payment.save!
      
      flash[:notice] = "Payments successfully generated"
      redirect_to admin_bulk_payments_path
    end
  end
  
  def ach
    send_data(@bulk_payment.ach_file, :filename => "#{@bulk_payment.id}_ach.ach")
  end
  
  def paypal
    send_data(@bulk_payment.paypal_file, :filename => "#{@bulk_payment.id}_paypal.tsv")
  end
  
  private
  
  def load_bulk_payment
    @bulk_payment = BulkPayment.find(params[:id])
  end
end

