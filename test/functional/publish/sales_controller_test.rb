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

    get :ledger, :publisher_id => @publisher.id
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

  test 'Export-to-CSV link on most views' do
    get :index, :publisher_id => @publisher.id
    assert_select 'p.btso button.b1', :text => 'Export to CSV'

    get :ledger, :publisher_id => @publisher.id
    assert_select 'a', :text => 'Export to CSV'
  end

  test 'proper display of monthly retail totals' do
    get :index, :publisher_id => @publisher.id, :year => 2010
    assert_response :success
    assert_select 'tr#october td.retail a', :html => '$44.97'
    assert_select 'tr#november td.retail a', :html => '$104.93'
    assert_select 'tr#december td.retail a', :html => '$74.95'
  end

  test 'proper display of retail grand totals' do
    get :index, :publisher_id => @publisher.id, :year => 2010
    assert_response :success
    assert_select 'tr#totals td.retail strong', :html => '$224.85'

    get :index, :publisher_id => @publisher.id
    assert_response :success
    assert_select 'tr#totals td.retail strong', :html => '$224.85'
  end

  test 'proper display of yearly payments' do
    get :index, :publisher_id => @publisher.id
    assert_response :success
    assert_select 'tr#2010 td.payment', :html => '$114.66'
  end

  test 'proper display of monthly payments' do
    get :index, :publisher_id => @publisher.id, :year => 2010
    assert_response :success
    assert_select 'tr#september td.payment', :html => '$76.44'
    assert_select 'tr#october td.payment', :html => '$38.22'
  end

  test 'index should respond to csv format' do
    get :index, :publisher_id => @publisher.id, :format => :csv
    assert_response :success
    assert_equal 'csv', @response.content_type
  end

  test 'ledger should respond to csv format' do
    get :ledger, :publisher_id => @publisher.id, :month => 11, :year => 2010, :type => :retail_sales, :format => :csv
    assert_response :success
    assert_equal 'csv', @response.content_type
  end
end
