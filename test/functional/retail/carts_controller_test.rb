require 'test_helper'

class Retail::CartsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @customer = customers(:grumpy)
    @customer.confirm!
    sign_in @customer
  end

  # lots to-do here...
  test "the truth" do
    assert true
  end
end

