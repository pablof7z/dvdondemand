require 'test_helper'

class Publish::GetStocksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @publisher = publishers(:john)
    @publisher.confirm!
    sign_in @publisher
  end

  test 'a bare proper index page' do
    get :index, :publisher_id => @publisher.id
    assert_response :success
  end
end
