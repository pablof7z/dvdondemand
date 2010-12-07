require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  def setup
    @order = orders(:one)
    @jane = publishers(:jane)
    @john = publishers(:john)
  end

  test 'assoc. order sales by named ref. fixtures' do
    assert_equal @order.sales.count, 2
    assert_equal @jane.sales.count, 1
    assert_equal @john.sales.count, 1
  end
end
