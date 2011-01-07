require 'test_helper'

class PublisherTest < ActiveSupport::TestCase
  def setup
    @john = publishers(:john)
    @jane = publishers(:jane)
  end

  test 'due payments totals for publisher' do
    assert_equal  19.98, @jane.sales.totals
    assert_equal  15.98, @jane.pending_payment_totals
    # actually with some payments made
    assert_equal 539.64, @john.sales.totals
    assert_equal 343.98, @john.pending_payment_totals
  end

  test 'due payments count for publisher' do
    # publisher with just retails sales
    assert_equal  1, @jane.sales.count
    assert_equal  1, @jane.sales.pending_payment.count
    assert_equal  0, @jane.get_stocks.pending_payment.count
    assert_equal  0, @jane.whole_sales.pending_payment.count
    assert_equal  1, @jane.retail_sales.pending_payment.count
    # publisher with many kind of sales
    assert_equal 10, @john.sales.count
    assert_equal  5, @john.sales.pending_payment.count
    assert_equal  0, @john.get_stocks.pending_payment.count
    assert_equal  2, @john.whole_sales.pending_payment.count
    assert_equal  3, @john.retail_sales.pending_payment.count
  end
end
