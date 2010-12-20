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
end
