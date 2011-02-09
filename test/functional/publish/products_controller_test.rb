require 'test_helper'

class Publish::ProductsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @foreigner = publishers(:john)
    @publisher = publishers(:jane)
    @publisher.confirm!
    sign_in @publisher

    @catalog = catalogs(:janes)
    @product = products(:janes)
  end

  test 'Products index at least require a Publisher' do
    assert_routing publish_publisher_products_path(@publisher),
      :controller   => 'publish/products',
      :action       => 'index',
      :publisher_id => @publisher.id.to_s
    assert_routing publish_publisher_catalog_products_path(@publisher,@catalog),
      :controller   => 'publish/products',
      :action       => 'index',
      :publisher_id => @publisher.id.to_s,
      :catalog_id   => @catalog.id.to_s
  end

  test 'proper products filtering if given Catalog in path (or not)' do
    # all publisher's products if no catalog given
    get :index, :publisher_id => @publisher.id.to_s
    assert_response :success
    assert_equal [], @publisher.products.available - assigns(:products)

    # filer publisher's products otherwise
    get :index, :publisher_id => @publisher.id.to_s, :catalog_id => @catalog.id.to_s
    assert_response :success
    assert_equal [], @catalog.products.available - assigns(:products)
  end

  test 'do not display foreign products' do
    get :index, :publisher_id => @foreigner.id
    assert_response 404
  end

  test 'pagination with harcoded per_page limit' do
    get :index, :publisher_id => @publisher.id.to_s, :per_page => 3
    assert_response :success
    assert_equal 3, assigns(:products).count
    assert_select '.pagination'
  end

  test 'soft-deletion of product reduces products availability' do
    assert_difference(['Product.available.count','@publisher.products.available.count'],-1) do
      delete :destroy, :publisher_id => @publisher.id, :id => @product.id
    end
    assert_redirected_to publish_publisher_products_url(@publisher)
  end

  test 'soft-deletion of product does not actually destroy it' do
    assert_no_difference(['Product.count','@publisher.products.count']) do
      delete :destroy, :publisher_id => @publisher.id, :id => @product.id
    end
    assert_redirected_to publish_publisher_products_url(@publisher)
  end
end
