require 'test_helper'

class Retail::CartControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @customer = customers(:grumpy)
    @customer.confirm!
    sign_in @customer
  end

  test 'empty cart when Customer just logged-in' do
    get :index
    assert_response :success
    assert assigns(:cart_items).empty?
  end
end

