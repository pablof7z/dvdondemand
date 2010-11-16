require 'test_helper'

class Publish::ProductsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @publisher = publishers(:jane)
    @publisher.confirm!
    sign_in @publisher

    @catalog = @publisher.catalogs.first
  end

  test 'Products index at least require a Publisher' do
    assert_raise ActiveRecord::RecordNotFound do
      get :index
    end
    # so also test proper routing rules
    assert_routing publish_publisher_products_path(@publisher), :controller => 'publish/products', :action => 'index', :publisher_id => @publisher.id.to_s
    assert_routing publish_publisher_catalog_products_path(@publisher,@catalog), :controller => 'publish/products', :action => 'index', :publisher_id => @publisher.id.to_s, :catalog_id => @catalog.id.to_s
  end

  test 'proper products filtering if given Catalog in path (or not)' do
    # all publisher's products if no catalog given
    get :index, :publisher_id => @publisher.id.to_s
    assert_response :success
    assert_equal assigns(:products), @publisher.products

    # filer publisher's products otherwise
    get :index, :publisher_id => @publisher.id.to_s, :catalog_id => @catalog.id.to_s
    assert_response :success
    assert_equal assigns(:products), @catalog.products
  end

end

