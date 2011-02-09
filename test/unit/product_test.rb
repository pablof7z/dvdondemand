require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @publisher = publishers(:jane)
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

  test 'deleted products are not available' do
    assert_equal 5, @publisher.products.count
    assert_equal 4, @publisher.products.available.count
    assert_equal 0, @publisher.products.for_retail.count
  end
end
