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

    # production fee is a fixed amount
    @production = fees(:production)
    # processing fee is a percentage amount
    @processing = fees(:processing)
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
    assert_equal 10, @john.sales.count
  end

  test "apply each Fee by product's sale" do
    assert_equal @production.amount*2 + 0.999, @jane.sales.first.fees
    assert_equal @production.amount*5 + 3.7475, @john.sales.first(:conditions => {:quantity => 5}).fees
  end

  test 'other STI sales existance by fixtures' do
    assert_equal  5, @john.retail_sales.count
    assert_equal  3, @john.whole_sales.count
    assert_equal  2, @john.get_stocks.count
    assert_equal 10, @john.sales.count
  end

  test 'sales totals by publisher by fixtures' do
    assert_equal 224.85, @john.retail_sales.sum(:total).round(2)
    assert_equal 314.79, @john.whole_sales.sum(:total).round(2)
    assert_equal 284.81, @john.get_stocks.sum(:total).round(2)
    assert_equal 824.45, @john.sales.sum(:total).round(2)
  end
end
