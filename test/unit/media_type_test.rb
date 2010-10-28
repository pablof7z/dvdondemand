require 'test_helper'

class MediaTypeTest < ActiveSupport::TestCase
  test "should pass some validations before saving" do
    mt = MediaType.new
    assert !mt.valid?
  end
end

