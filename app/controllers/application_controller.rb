# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  layout :layout_by_devise_resource

  def sign_out(resource_or_scope)
    current_customer.cart.destroy if (resource_or_scope.is_a?(Customer) || resource_or_scope == :customer) && !current_customer.cart.blank?
    super
  end

  private

  def layout_by_devise_resource
    if devise_controller?
      case resource_name
        when :admin      then 'admin'
        when :customer   then 'retail'
        when :publisher  then 'publish'
        when :wholesaler then 'wholesale'
      end
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
      when :admin     then root_path
      when :customer  then root_path
      when :publisher then publish_root_path
      when :wholesaler then wholesale_root_path
    end
  end
end

