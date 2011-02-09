require 'test_helper'

class PublisherTest < ActiveSupport::TestCase
  def setup
    @john = publishers(:john)
    @jane = publishers(:jane)
  end

  test 'available publishers' do
    assert_equal 3, Publisher.all.count
    assert_equal 2, Publisher.approved.count
  end

  if Publisher.respond_to? :balance
    test 'balance totals by publisher' do
      assert_equal  15.83, @jane.balance
      assert_equal 315.13, @john.balance
    end
  end
end
