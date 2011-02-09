require 'test_helper'

class Admin::FeesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @admin = admins(:joe)
    # admin user is not confirmable
    sign_in @admin
  end

  test 'available Fees (non soft-deleted)' do
    get :index
    assert_response :success
    assert_not_nil assigns(:fees)
    assert_equal 2, assigns(:fees).count
    assert_equal 3, Fee.all.count
  end
end
