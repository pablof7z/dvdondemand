class RetailController < InheritedResources::Base
  before_filter :auto_sign_in
  layout 'retail'

  protected
  def auto_sign_in
    sign_in(:customer, Customer.anonymous) unless customer_signed_in?
    if (cart_id = session.delete(:cart_id)) and current_customer.cart.blank?
      begin
        Cart.find(cart_id).assign_customer(current_customer)
      rescue ActiveRecord::RecordNotFound
      end
    end
  end
end
