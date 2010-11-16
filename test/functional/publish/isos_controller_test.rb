require 'test_helper'

class Publish::IsosControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @publisher = publishers(:jane)
    @publisher.confirm!
    sign_in @publisher
  end

  test 'in InheritedResources excluded actions we trust' do
    # because we use :has_many in Products routing and we can't include :only actions with it
    assert_raise(ActionController::UnknownAction) { get :update }
    assert_raise(ActionController::UnknownAction) { get :index }
    assert_raise(ActionController::UnknownAction) { get :edit }
    assert_raise(ActionController::UnknownAction) { get :new }
  end
end

