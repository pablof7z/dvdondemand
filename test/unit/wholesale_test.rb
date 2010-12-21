require 'test_helper'

class WholesaleTest < ActiveSupport::TestCase
  def setup
    @john = publishers(:john)
  end

  test 'Wholesale sales named fixtures and STI' do
    assert_equal 10, @john.sales.count
    assert_equal 5, @john.whole_sales.count
  end
end
