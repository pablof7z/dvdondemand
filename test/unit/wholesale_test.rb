require 'test_helper'

class WholesaleTest < ActiveSupport::TestCase
  test 'Wholesale named fixtures and STI' do
    assert_equal 11, Sale.all.count
    assert_equal 5, Wholesale.all.count
  end
end
