require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "should pass some validations before saving" do
    product = Product.new
    assert !product.valid?
  end
end

