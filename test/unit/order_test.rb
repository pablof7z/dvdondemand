require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:one)
    @john   = publishers(:john)
    @jane   = publishers(:jane)
    @newbie = publishers(:newbie)
    @customer = customers(:happy)
  end

  test "composite billing address" do
    assert_equal @order.billing_address, "Vucetich<br />Nieva<br />Smallville<br />UT<br />US"
  end

  test "composite shipping address" do
    assert_equal @order.shipping_address, "Vucetich<br />Nieva<br />Smallville<br />UT<br />US"
  end

  test 'customer totals by named ref. fixtures' do
    assert_equal 1, @customer.orders.size
  end

  test 'order totals by named ref. fixtures' do
    assert_equal     3, @order.items_full_count
    assert_equal  4372, @order.total_in_cents
    assert_equal 37.97, @order.subtotal 
    assert_equal 43.72, @order.total
  end

  test 'john items_from convenience method' do
    assert_equal 1, @order.items_from(@john).size
  end

  test 'jane items_from convenience method' do
    assert_equal 1, @order.items_from(@jane).size
  end

  test 'newbie items_from convenience method' do
    assert_equal 0, @order.items_from(@newbie).size
  end
end
