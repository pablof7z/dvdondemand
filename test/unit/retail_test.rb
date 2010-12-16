require 'test_helper'

class RetailTest < ActiveSupport::TestCase
  test 'Retail named fixtures and STI' do
    assert_equal 11, Sale.all.count
    assert_equal 6, Retail.all.count
  end
end
