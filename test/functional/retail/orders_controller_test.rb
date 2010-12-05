require 'test_helper'

class Retail::OrdersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @customer = customers(:grumpy)
    @customer.confirm!
    sign_in @customer
  end

  test "in InheritedResources excluded actions we trust" do
    # because we use :has_many in Customers routing and we can't include :only actions with it
    assert_raise(ActionController::UnknownAction) { get :index }
    assert_raise(ActionController::UnknownAction) { get :edit }
    assert_raise(ActionController::UnknownAction) { get :update }
  end

  test 'do not proceed to Order creation with an empty cart' do
    get :new
    assert_redirected_to root_url
    get :create
    assert_redirected_to root_url
  end
end

