class Retail::SessionController < ApplicationController
  layout 'retail'

  def login
    if current_customer and current_customer.anonymous
      session[:cart_id] = current_customer.cart unless current_customer.cart.blank?
      current_customer.destroy
    end
    redirect_to new_customer_session_path
  end

  def sign_up
    session[:cart_id] = current_customer.cart unless current_customer.cart.blank?
    if params[:checkout] == 'true'
      current_customer.destroy if current_customer
      @user = Customer.new
    else
      if current_customer and current_customer.anonymous
        current_customer.destroy
      end
      redirect_to new_customer_registration_path
    end
  end

  def register
    @user = Customer.new(params[:customer])
    if @user.save
      @user.confirm!
      sign_in(:customer, @user)
      redirect_to new_retail_customer_order_path(@user)
    else
      render :action => :sign_up
    end
  end

end
