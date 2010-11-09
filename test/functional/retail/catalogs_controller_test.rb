require 'test_helper'

class Retail::CatalogsControllerTest < ActionController::TestCase
  test "should respond with 403 for private Catalog" do
    get :show, :id => 3
    assert_response :forbidden
  end
end

