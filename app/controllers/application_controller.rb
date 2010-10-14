# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  layout :layout_by_devise_resource

  private

  def layout_by_devise_resource
    if devise_controller?
      case resource_name
        when :customer  then 'retail'
        when :publisher then 'publish'
      end
    else
      # this will surely *have* to be changed sometime
      'admin'
    end
  end
end

