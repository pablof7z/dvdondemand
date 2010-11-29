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
end

