require 'test_helper'

class Admin::PublishersControllerTest < ActionController::TestCase
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

  test 'publishers collection pagination with harcoded per_page limit' do
    get :index, :per_page => 2
    assert_equal 2, assigns(:publishers).count
    assert_select '.pagination'
  end
end
