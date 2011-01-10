# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# Devise requirement
config.action_mailer.default_url_options = { :host => 'localhost:3000' }

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
  ActiveMerchant::Billing::LinkpointGateway.pem_file = File.read(File.dirname(__FILE__) + '/1909055592.pem')
  ::GATEWAY = ActiveMerchant::Billing::LinkpointGateway.new(:login => "1909055592")
end

DOMAIN="behindthestation.com"
SITE="Behind The Station"
URL="http://www.behindthestation.com"
