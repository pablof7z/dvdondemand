require 'test_helper'

class Publish::CatalogsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @publisher = publishers(:jane)
    @publisher.confirm!
    sign_in @publisher
    @catalog = catalogs(:janes)
  end

  test 'Catalogs index always require a Publisher' do
    assert_raise ActionController::RoutingError do
      get :index
    end
    # so proper routing should be in order
    assert_routing publish_publisher_catalogs_path(@publisher),
      :controller   => 'publish/catalogs',
      :action       => 'index',
      :publisher_id => @publisher.id.to_s
  end

  test 'Catalogs index are per-Publisher' do
    get :index, :publisher_id => @publisher.id
    assert_response :success
    # and shoud only list current Publisher's catalogs and none other's
    assert_equal assigns(:catalogs), @publisher.catalogs
  end

  test 'products collection set along catalog' do
    get :show, :publisher_id => @publisher.id, :id => @catalog.id
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test 'products collection pagination with harcoded per_page limit' do
    get :show, :publisher_id => @publisher.id, :id => @catalog.id, :per_page => 3
    assert_response :success
    assert_equal 3, assigns(:products).count
    assert_select '.pagination'
  end
end
