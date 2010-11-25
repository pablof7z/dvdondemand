class PublishController < InheritedResources::Base
  before_filter :authenticate_publisher!
  layout 'fafo'
end

