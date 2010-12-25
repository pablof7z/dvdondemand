require 'test_helper'

class PublisherTest < ActiveSupport::TestCase
  def setup
    @john = publishers(:john)
    @jane = publishers(:jane)
  end

  test "assoc. catalogs & products by named ref. fixtures" do
    assert_equal @john.catalogs.size, 1
    assert_equal @john.products.size, 1
    assert_equal @jane.catalogs.size, 2
    assert_equal @jane.products.size, 1
  end
  
  test 'due payments total for publisher' do
    assert_equal  19.98, @jane.sales.totals
    assert_equal  15.98, @jane.pending_payment_totals
    assert_equal 824.45, @john.sales.totals
    assert_equal 707.45, @john.pending_payment_totals
  end
end
