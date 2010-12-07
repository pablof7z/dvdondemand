require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:one)
    @customer = customers(:happy)
  end

  test "composite billing address" do
    assert_equal @order.billing_address, "Vucetich<br />Nieva<br />Smallville<br />UT<br />US"
  end

  test "composite shipping address" do
    assert_equal @order.shipping_address, "Vucetich<br />Nieva<br />Smallville<br />UT<br />US"
  end

  test 'named referenced fixtures' do
    assert_equal @customer.orders.size, 1
    assert_equal @order.items_full_count, 3
    assert_equal @order.subtotal, 37.97
    assert_equal @order.total, 43.72
  end
end
