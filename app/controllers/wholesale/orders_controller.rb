class Wholesale::OrdersController < WholesaleController
  before_filter :authenticate_wholesaler!, :except => [ :create ]
  belongs_to :wholesaler
  respond_to :xml
  skip_before_filter :verify_authenticity_token
  
  def create
    # Get wholesaler
    @wholesaler = Wholesaler.find_by_api_key(params[:api_key])
    
    raise { :error => "Invalid api" } if @wholesaler == nil
    
    # Get invoice
    @wholesaler_invoice = @wholesaler.current_invoice
    
    # Create order
    @order = Order.new
    @order.wholesaler = @wholesaler
    @order.items.build(
        :packaging_option_id => 1,
        :product_id          => 3,
        :quantity            => 1,
        :price               => 11.99
    )
    @order.save

    # Create customer
    raise { :error => "Missing information" } if params[:customer].blank?

    @customer = Customer.find(:first, :conditions => { :email => params[:customer][:email], :wholesaler_id => @wholesaler.id }) || Customer.new
    @customer.update_attributes(params[:customer])
    @customer.email = params[:customer][:email]
    @customer.wholesaler = @wholesaler
    @customer.password = "blahblah"
    raise @customer.errors if ! @customer.save
    
    # Create order
    @order = Order.new
    @order.customer = @customer
    
    # Create order items
    raise { :error => "Missing information" } if params[:items].blank?

    params[:items].each do |item|
      raise { :error => "Missing information" } if item == nil or item[:product_id].blank? or item[:packaging_option_id].blank? or item[:quantity].blank?
      
      # Get product
      raise { :error => "Invalid product #{item[:product_id]}" } if Product.find(item[:product_id]) rescue nil
      
      # Get packaging
      { :error => "Invalid packaging option #{item[:packaging_option_id]}" } if PackagingOption.find(item[:packaging_option_id]) rescue nil
      
      order_item = OrderItem.new
      order_item.packaging_option = packaging_option
      order_item.product = product
      order_item.quantity = item[:quantity]
      order_item.price = product.price
    end
    
    respond_to do |format|
      format.xml { render :xml => @order.to_xml(:include => [ :customer, :wholesaler ]), :status => :created }
    end
    
    # Create sale
    @order.to_retail_sale
    
    # Add to invoice
    @order.sales.each do |sale|
    end
  rescue
    respond_to do |format|
      format.xml { render :xml => { :error => $! }, :status => "404" }
    end
  end
end
