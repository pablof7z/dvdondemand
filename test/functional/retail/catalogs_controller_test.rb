require 'test_helper'

class Retail::CatalogsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @private = catalogs(:janes_private)
  end

  test "should respond with 403 for private Catalog" do
    get :show, :id => @private.id
    assert_response :forbidden
  end
end

