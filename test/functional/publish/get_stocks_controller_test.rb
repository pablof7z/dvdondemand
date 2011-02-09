require 'test_helper'

class Publish::GetStocksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @foreigner = publishers(:jane)
    @publisher = publishers(:john)
    @publisher.confirm!
    sign_in @publisher
  end

  test 'a bare proper index page' do
    get :index, :publisher_id => @publisher.id
    assert_response :success
  end

  test 'a bare proper show page' do
    get :show, :publisher_id => @publisher.id, :id => @sale.id
    assert_response :success
  end

  test 'do not display foreign get_stocks' do
    get :index, :publisher_id => @foreigner.id
    assert_response 404
  end
end
