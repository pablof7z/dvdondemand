class Admin::BulkPaymentsController < AdminController
  before_filter :load_bulk_payment, :only => [ :ach, :paypal ]
  
  def generate
    unless request.post?
      @publishers = Publisher.all.map { |p| p if p.owed > 0 and p.approved }.compact
    else
      if params[:publisher] == nil or params[:publisher].empty?
        flash[:warning] = "No publisher accounts selected"
        redirect_to generate_admin_publisher_payment_path(1) and return
      end
      
      bulk_payment = BulkPayment.new
      bulk_payment.save!
      
      # Go through each selected publisher
      params[:publisher].each do |i|
        # Get the publisher
        publisher = Publisher.find(i)
        sales = publisher.sales_owed
        
        # Create the payment
        publisher_payment = PublisherPayment.new(:publisher => publisher,
                                                 :amount => publisher.owed,
                                                 :memo => "Payment created by #{current_admin.email}",
                                                 :financial_information => publisher.default_financial_information,
                                                 :bulk_payment => bulk_payment)
        
        # Save payment
        if ! publisher_payment.save
          flash[:warning] = "Publisher payment couldn't be created for #{publisher.full_name}"
          redirect_to generate_admin_publisher_payment_path(1) and return
        else
          sales.each do |sale|
            sale.publisher_payment = publisher_payment
            sale.save!
            
            # Add payment to ach file
            # Add payment to paypal file
            bulk_payment.add_publisher_payment(publisher_payment)
          end
        end
      end
      
      bulk_payment.fixate
      bulk_payment.save!
      
      flash[:notice] = "Payments successfully generated"
      redirect_to admin_bulk_payments_path
    end
  end
  
  def ach
    send_data(@bulk_payment.ach, :filename => "#{@bulk_payment.id}_ach.ach")
  end
  
  def paypal
    send_data(@bulk_payment.paypal, :filename => "#{@bulk_payment.id}_paypal.tsv")
  end
  
  private
  
  def load_bulk_payment
    @bulk_payment = BulkPayment.find(params[:id])
  end
end

