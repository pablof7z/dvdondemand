class Admin::PublisherPaymentsController < AdminController
  def generate
    unless request.post?
      @publishers = Publisher.all.map { |p| p if p.owed > 0 and p.approved }.compact
    else
      if params[:publisher] == nil or params[:publisher].empty?
        flash[:warning] = "No publisher accounts selected"
        redirect_to generate_admin_publisher_payment_path(1) and return
      end
      
      # Create NACHA class
      
      # Go through each selected publisher
      params[:publisher].each do |i|
        # Get the publisher
        publisher = Publisher.find(i)
        sales = publisher.sales_owed
        
        # Create the payment
        publisher_payment = PublisherPayment.new(:publisher => publisher, :amount => publisher.owed, :memo => "Payment file created by #{current_admin.email}", :bank_information => publisher.default_bank_information)
        
        # Save payment
        if ! publisher_payment.save
          flash[:warning] = "Publisher payment couldn't be created for #{publisher.full_name}"
          redirect_to generate_admin_publisher_payment_path(1) and return
        else
          sales.each do |sale|
            sale.publisher_payment = publisher_payment
            sale.save!
            
            # Add payment to ach file
            flash[:notice] = "Payments successfully generated" # XXX Get rid of this once ach is integrated
            redirect_to admin_publisher_payments_path          # XXX Get rid of this once ach is integrated
          end
        end
      end
      
      # Prompt user to download ach file
    end
  end
end

