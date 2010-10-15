# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  layout :layout_by_devise_resource

  private

  # custom layout according to Devise resource thanks to http://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts
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

  # custom sign out redirection according to Devise resource thanks to http://github.com/plataformatec/devise/wiki/How-To:-Change-the-redirect-path-after-destroying-a-session-%28signing-out%29
  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
      when :customer  then root_path
      when :publisher then publish_root_path
    end
  end
end

