require 'test_helper'

class FeeTest < ActiveSupport::TestCase
  test "only applicable Fees available" do
    assert_equal 3, Fee.all.count
    assert_equal 2, Fee.applicable.count
  end
end
