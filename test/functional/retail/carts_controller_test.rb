require 'test_helper'

class Retail::CartsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @foreigner = customers(:happy)
    @customer  = customers(:grumpy)
    @customer.confirm!
    sign_in @customer
  end

  test "redirect to home on empty cart" do
    get :show, :customer_id => @customer.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'do not display foreign cart' do
    get :show, :customer_id => @foreigner.id
    assert_response 404
  end
end
