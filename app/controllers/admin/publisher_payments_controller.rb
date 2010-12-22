class Admin::PublisherPaymentsController < AdminController
  def generate
    unless request.post?
      @publishers = Publisher.all.map { |p| p if p.owed > 0 and p.approved }.compact
    else
      if params[:publisher] == nil or params[:publisher].empty?
        flash[:warning] = "No publisher accounts selected"
        redirect_to generate_admin_publisher_payment_path(1) and return
      end
      
      params[:publisher].each do |i|
        publisher = Publisher.find(i)
        sales = publisher.sales_owed
        publisher_payment = PublisherPayment.new(:publisher => publisher, :amount => publisher.owed, :memo => "Payment file created by #{current_admin.email}", :bank_information => publisher.default_bank_information)
        if ! publisher_payment.save
          flash[:warning] = "Publisher payment couldn't be created for #{publisher.full_name}"
          redirect_to generate_admin_publisher_payment_path(1) and return
        else
          sales.each do |sale|
            sale.publisher_payment = publisher_payment
            sale.save!
            flash[:notice] = "Payments successfully generated"
            redirect_to admin_publisher_payments_path
          end
        end
      end
    end
  end
end

