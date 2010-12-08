require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    # default packaging options available
    @standard = packaging_options(:standard)
    @premium  = packaging_options(:premium)
    @amary    = packaging_options(:amary)
    # products w/packaging options
    @product_with_no_pack = products(:devises)
    @product_with_premium = products(:johns)
    @product_with_amary   = products(:janes)
  end

  test "should pass some validations before saving" do
    product = Product.new
    assert !product.valid?
  end

  test 'assoc. packaging options w/fixtures' do
    assert @product_with_no_pack.packaging_options.blank?
    assert @product_with_premium.available_packaging_options.include? @premium
    assert @product_with_amary.available_packaging_options.include? @amary
  end

  test 'packaging options should always include StandardClamshell ($0)' do
    assert @product_with_no_pack.available_packaging_options.include? @standard
    assert @product_with_premium.available_packaging_options.include? @standard
    assert @product_with_amary.available_packaging_options.include? @standard
  end
end

