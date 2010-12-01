require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:one)
  end

  test "composite billing address" do
    assert_equal @order.billing_address, "Vucetich<br />Nieva<br />Smallville<br />UT<br />US"
  end

  test "composite shipping address" do
    assert_equal @order.shipping_address, "Vucetich<br />Nieva<br />Smallville<br />UT<br />US"
  end
end
