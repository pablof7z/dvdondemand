class Retail::OrdersController < RetailController
  before_filter :authenticate_customer!
  before_filter :prevent_session_hijack
  before_filter :no_empty_cart, :only => [:new, :create]
  belongs_to :customer
  actions :new, :create, :index, :show

  def new
    @order ||= current_customer.orders.build
#    unless @order.items.blank?
      current_customer.cart.items.each do |item|
        @order.items.build(
          :packaging_option_id => item.packaging_option.id,
          :product_id          => item.product.id,
          :quantity            => item.quantity,
          :price               => item.product.price
        )
      end
#    end
    new!
  end

  def create
    create! do |success, failure|
      success.html do
        current_customer.cart.destroy
        # Order was created, but FirstData pay. gw. could fail the purchase
        if @order.purchase
          # order is cashed, so make it a real Retail sale
          @order.to_retail_sale
          render :action => :success
        else
          render :action => :failure
        end
      end
      failure.html { render :action => :new }
    end
  end

  def show
    show! { render :partial => 'receipt', :layout => 'receipt' and return if params[:printable] == 'true' }
  end
 
  private

  def collection
    @orders ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || Order.per_page
  end

  def prevent_session_hijack
    render(:file => "#{RAILS_ROOT}/public/404.html", :status => 404) if params[:customer_id].to_i != current_customer.id
  end

  def no_empty_cart
    redirect_to root_url and return if current_customer.cart.blank?
  end
end
