class Retail::CartsController < RetailController
  before_filter :authenticate_customer!
  before_filter :prevent_session_hijack
  belongs_to :customer, :singleton => true

  def show
    show! { redirect_to root_url and return if current_customer.cart.blank? }
  end

  def destroy
    destroy! { root_url }
  end

  private

  def prevent_session_hijack
    render(:file => "#{RAILS_ROOT}/public/404.html", :status => 404) if params[:customer_id].to_i != current_customer.id
  end
end
