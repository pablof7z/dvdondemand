class Wholesale::OrdersController < WholesaleController
  before_filter :authenticate_wholesaler!, :except => [ :new ]
  belongs_to :wholesaler
  respond_to :xml
  actions :new, :create
  
  def new
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
    @order.items << OrderItem.new
    @order.items << OrderItem.new
    @order.items << OrderItem.new
    @order.items << OrderItem.new
    @order.wholesaler = @wholesaler
    @order.save
    
    respond_to do |format|
      format.xml { render :xml => @order, :status => :created }
    end

    return
    # Create customer
    @customer = Customer.find_or_create_by_email(params[:customer][:email])
    
    # Create order
    @order = Order.new
    @order.customer = @customer
    
    # Create order items
    
  end
end
