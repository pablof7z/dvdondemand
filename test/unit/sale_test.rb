require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  def setup
    @order1 = orders(:one)
    @order2 = orders(:two)
    @order3 = orders(:three)
    @order4 = orders(:four)
    @order5 = orders(:five)
    @jane = publishers(:jane)
    @john = publishers(:john)
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
end
