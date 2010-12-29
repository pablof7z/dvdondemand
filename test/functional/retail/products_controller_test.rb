require 'test_helper'

class Retail::ProductsControllerTest < ActionController::TestCase
  def setup
    @foreing = catalogs(:johns)
    @private = catalogs(:janes_private)
    @product = products(:janes)
    @deleted = products(:janes_deleted)
  end

  test "products routes always along with catalogs'" do
    assert_routing '/retail/catalogs/1/products/1', :controller => 'retail/products', :action => 'show', :catalog_id => '1', :id => '1'
  end

  test "should respond with 403 for private Catalog association" do
    get :show, :catalog_id => @private.id, :id => @product.id
    assert_response :forbidden
  end

  test "should respond with 404 for wrong Catalog association" do
    get :show, :catalog_id => @foreing.id, :id => @product.id
    assert_response :missing
  end

  test 'forbid direct access to deleted products' do
    get :show, :catalog_id => @deleted.catalogs.first.id, :id => @deleted.id
    assert_response :forbidden
  end
end

