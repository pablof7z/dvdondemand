require 'test_helper'

class Publish::SalesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @publisher = publishers(:john)
    @publisher.confirm!
    sign_in @publisher
    @sale = @publisher.sales.first
  end

  test 'restricted routing rules' do
    get :index, :publisher_id => @publisher.id
    assert_response :success
    get :show, :publisher_id => @publisher.id, :id => @sale.id
    assert_response :success
    assert_raise ActionController::RoutingError do
      get :edit, :publisher_id => @publisher.id
    end
  end

  test 'full sale sub-menu navigation' do
    get :show, :publisher_id => @publisher.id, :id => @sale.id
    assert_select 'ul.secondary-nav.for_sales li', 4
  end
end
