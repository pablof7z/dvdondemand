require 'test_helper'

class Retail::ProductsControllerTest < ActionController::TestCase

  test "products routes always along with catalogs'" do
    assert_routing '/retail/catalogs/1/products/1', :controller => 'retail/products', :action => 'show', :catalog_id => '1', :id => '1'
  end

  test "should respond with 403 for private Catalog association" do
    get :show, :catalog_id => 3, :id => 2
    assert_response :forbidden
  end

  test "should respond with 404 for wrong Catalog association" do
    get :show, :catalog_id => 1, :id => 2
    assert_response :missing
  end
end

