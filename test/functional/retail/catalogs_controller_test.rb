require 'test_helper'

class Retail::CatalogsControllerTest < ActionController::TestCase

  test "should respond with 403 for private Catalog" do
    @private = catalogs(:janes_private)
    get :show, :id => @private.id
    assert_response :forbidden
  end

end

