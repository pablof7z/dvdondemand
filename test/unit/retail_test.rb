require 'test_helper'

class RetailTest < ActiveSupport::TestCase
  def setup
    @john = publishers(:john)
  end

  test 'Retail named fixtures and STI' do
    assert_equal 10, @john.sales.count
    assert_equal 5, @john.retail_sales.count
  end
end
