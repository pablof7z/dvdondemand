require 'test_helper'

class Retail::CatalogsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @public  = catalogs(:janes)
    @private = catalogs(:janes_private)
  end

  test "should respond with 403 for private Catalog" do
    get :show, :id => @private.id
    assert_response :forbidden
  end

  test 'a barely working index and show views' do
    get :index
    assert_response :success
    get :show, :id => @public.id
    assert_response :success
  end
end
