require 'test_helper'

class Admin::ShippingOptionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @admin = admins(:joe)
    # admin user is not confirmable
    sign_in @admin
  end

  test 'a barely working index page' do
    get :index
    assert_response :success
  end

  test 'shipping options collection pagination with harcoded per_page limit' do
    get :index, :per_page => 1
    assert_equal 1, assigns(:shipping_options).count
    assert_select '.pagination'
  end
end
