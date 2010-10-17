class Publish::PublishController < InheritedResources::Base
  before_filter :authenticate_publisher!

  layout 'publish'
end

