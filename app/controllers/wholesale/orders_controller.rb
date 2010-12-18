class Wholesale::OrdersController < WholesaleController
  before_filter :authenticate_wholesaler!, :except => [ :create ]
  belongs_to :wholesaler
  respond_to :xml
  skip_before_filter :verify_authenticity_token
  
  def create
    # Get wholesaler
    @wholesaler = Wholesaler.find_by_api_key(params[:api_key])
    
    if @wholesaler == nil
      @wholesaler = Wholesaler.new
      
      respond_to do |format|
        format.xml { render :xml => { :error => "Invalid api" }, :status => "404" }
      end
      
      return
    end
    
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
    if params[:customer].blank?
      respond_to do |format|
        format.xml { render :xml => { :error => "Missing information" }, :status => "404" }
      end
      return
    end
    @customer = Customer.find(:first, :conditions => { :email => params[:customer][:email], :wholesaler_id => @wholesaler.id }) || Customer.new
    @customer.update_attributes(params[:customer])
    @customer.email = params[:customer][:email]
    @customer.wholesaler = @wholesaler
    @customer.password = "blahblah"
    if ! @customer.save
      respond_to do |format|
        format.xml { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
      return
    end
    
    # Create order
    @order = Order.new
    @order.customer = @customer
    
    # Create order items
    if params[:items].blank?
      respond_to do |format|
        format.xml { render :xml => { :error => "Missing information" }, :status => "404" }
      end
      return
    end
    params[:items].each do |item|
      if item == nil or item[:product_id].blank? or item[:packaging_option_id].blank? or item[:quantity].blank?
        respond_to do |format|
          format.xml { render :xml => { :error => "Missing information" }, :status => "404" }
        end
        return
      end
      
      # Get product
      product = Product.find(item[:product_id]) rescue nil
      
      if product == nil
        respond_to do |format|
          format.xml { render :xml => { :error => "Invalid product #{item[:product_id]}" }, :status => "404" }
        end
        return
      end
      
      # Get packaging
      packaging_option = PackagingOption.find(item[:packaging_option_id]) rescue nil
      
      if packaging_option == nil
        respond_to do |format|
          format.xml { render :xml => { :error => "Invalid packaging option #{item[:packaging_option_id]}" }, :status => "404" }
        end
        return
      end
      
      order_item = OrderItem.new
      order_item.packaging_option = packaging_option
      order_item.product = product
      order_item.quantity = item[:quantity]
      order_item.price = product.price
    end
    
    respond_to do |format|
      format.xml { render :xml => @order.to_xml(:include => [ :customer, :wholesaler ]), :status => :created }
    end
  end
end
