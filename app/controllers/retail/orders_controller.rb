class Retail::OrdersController < RetailController
  before_filter :authenticate_customer!
  before_filter :no_empty_cart, :only => [:new, :create]
  belongs_to :customer
  actions :new, :create

  def new
    if current_customer.anonymous
      current_customer.first_name =
      current_customer.last_name  =
      current_customer.email      =
      current_customer.address1   = 
      current_customer.city       = ''
    end
    create_new_order!
    new!
  end

  def create
    if (user = params.delete(:user))
      current_customer.first_name = params[:order][:first_name] = user[:first_name]
      current_customer.last_name  = params[:order][:last_name] = user[:last_name]
      current_customer.email      = user[:email]
      current_customer.password   = user[:password]
      current_customer.password_confirmation = user[:password_confirmation]
      current_customer.address1   = params[:order][:billing_address1] 
      current_customer.address2   = params[:order][:billing_address2] 
      current_customer.city       = params[:order][:billing_city]
      current_customer.state      = params[:order][:billing_state]
      current_customer.zip_code   = params[:order][:billing_zip_code]
      current_customer.country    = params[:order][:billing_country]
      current_customer.anonymous  = false

      unless current_customer.save
        current_customer.anonymous = true
        create_new_order!
        current_customer.errors.each { |*error| @order.errors.add(*error) }
        render :action => :new
        return 
      end
    end

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

  private

  def no_empty_cart
    redirect_to root_url and return if current_customer.cart.blank?
  end

  def create_new_order!
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
  end
end

