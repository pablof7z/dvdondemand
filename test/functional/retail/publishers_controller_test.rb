require 'test_helper'

class Retail::PublishersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'a barely working index page' do
    get :index
    assert_response :success
  end

  test 'publishers collection pagination with harcoded per_page limit' do
    get :index, :per_page => 1
    assert_equal 1, assigns(:publishers).count
    assert_select '.pagination'
  end
end
