class Wholesale::OrdersController < WholesaleController
  before_filter :authenticate_wholesaler!, :except => [ :create ]
  belongs_to :wholesaler
  respond_to :xml
  skip_before_filter :verify_authenticity_token
  
  def create
    # Get wholesaler
    @wholesaler = Wholesaler.find_by_api_key(params[:api_key])
    
    raise "Invalid api" if @wholesaler == nil

    # Create customer
    raise "Missing information" if params[:customer].blank?

    @customer = Customer.find(:first, :conditions => { :email => params[:customer][:email], :wholesaler_id => @wholesaler.id }) || Customer.new
    @customer.update_attributes(params[:customer])
    @customer.email = params[:customer][:email]
    @customer.wholesaler = @wholesaler
    @customer.password = "blahblah"
    raise @customer.errors if ! @customer.save
    
    # Create order
    @order = Order.new
    @order.customer = @customer
    @order.wholesaler = @wholesaler
    
    # ShippingOption
    @order.shipping_option = ShippingOption.find(params[:shipping_option_id]) rescue nil
    raise "Invalid shipping option #{params[:shipping_option_id]}" if @order.shipping_option == nil
    
    # Create order items
    raise "Missing information" if params[:items].blank?

    params[:items].each do |item|
      raise "Missing information" if item == nil or item[:product_id].blank? or item[:packaging_option_id].blank? or item[:quantity].blank?
      
      # Get product
      product = Product.find(item[:product_id]) rescue nil
      raise "Invalid product #{item[:product_id]}" if product == nil
      
      # Get packaging
      raise "Invalid packaging option #{item[:packaging_option_id]}" if PackagingOption.find(item[:packaging_option_id]) rescue nil
      
      order_item = OrderItem.new
      order_item.packaging_option_id = item[:packaging_option_id]
      order_item.product_id = item[:product_id]
      order_item.quantity = item[:quantity]
      order_item.price = product.price
      
      @order.items << order_item
    end
    
    raise "Wholesale account would owe past the credit limit with this sale" if @wholesaler.money_owed + @order.total > WHOLESALER_CREDIT_LIMIT
    
    @order.save!
    
    respond_to do |format|
      format.xml { render :xml => @order.to_xml(:include => [ :customer, :wholesaler ]), :status => :created }
    end
    
    # Create sale
    @order.to_retail_sale
    
    # Get invoice
    @wholesaler_invoice = @wholesaler.current_invoice
    
    # Add to invoice
    Sale.find(:all, :conditions => { :order_id => @order.id }).each do |sale|
      @wholesaler_invoice.sales << sale
      sale.save
    end
  rescue
    respond_to do |format|
      format.xml { render :xml => { :error => $! }, :status => "404" }
    end
  end
end
