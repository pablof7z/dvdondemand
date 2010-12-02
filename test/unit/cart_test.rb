require 'test_helper'

class CartTest < ActiveSupport::TestCase
  def setup
    @customer = customers(:happy)
    @product = products(:johns)
  end

  test "check cart totals" do
    assert_equal @customer.cart.items_total_count, 3
    assert_equal @customer.cart.items_total_price, 6.5
  end

  test 'check cart inclusion' do
    assert @customer.cart.items_include?(@product)
  end
end
