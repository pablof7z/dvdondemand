require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  def setup
    # all following orders are john's
    @order1 = orders(:one)
    @order2 = orders(:two)
    @order3 = orders(:three)
    @order4 = orders(:four)
    @order5 = orders(:five)
    @john = publishers(:john)
    # jane also has one sale
    @jane = publishers(:jane)
    # doh
    @production = fees(:production).amount
    @processing = fees(:processing).amount
  end

  test 'assoc. orders by named ref. fixtures' do
    assert_equal 2, @order1.sales.count
    assert_equal 1, @order2.sales.count
    assert_equal 1, @order3.sales.count
    assert_equal 1, @order4.sales.count
    assert_equal 1, @order5.sales.count
  end

  test 'assoc. publisher sales by named ref. fixtures' do
    assert_equal 1, @jane.sales.count
    assert_equal 5, @john.sales.count
  end

  test "apply each Fee by product's sale" do
    assert_equal @production*2+@processing*2, @jane.sales.first.fees
    assert_equal @production*5+@processing*5, @john.sales.last.fees
  end
end
