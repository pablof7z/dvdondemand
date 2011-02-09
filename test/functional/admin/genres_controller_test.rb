require 'test_helper'

class Admin::GenresControllerTest < ActionController::TestCase
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

  test 'genres collection pagination' do
    get :index
    assert_select '.pagination'
  end

  test 'genres collection pagination with harcoded per_page limit' do
    get :index, :per_page => 3
    assert_equal 3, assigns(:genres).count
    assert_select '.pagination'
  end
end
