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
        when :admin     then 'admin'
        when :customer  then 'retail'
        when :publisher then 'publish'
      end
    else
      # this will surely *have* to be changed sometime
      'admin'
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
      when :admin     then root_path
      when :customer  then root_path
      when :publisher then publish_root_path
    end
  end
end

