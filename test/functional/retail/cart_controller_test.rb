require 'test_helper'

class Retail::CartControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @customer = customers(:grumpy)
    @customer.confirm!
    sign_in @customer
  end

  test 'have an empty cart when Customer just logged-in' do
    get :index
    assert_response :success
    assert assigns(:cart_items).empty?
  end

  test 'add one Product to Cart and redirect' do
    post :add_item, { 'item[catalog_id]' => '1', 'item[product_id]' => '1', 'item[qty]' => '1', 'item[price]' => '14.99' }
    assert_redirected_to retail_cart_path
  end

end

