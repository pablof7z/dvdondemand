class PublishController < InheritedResources::Base
  before_filter :authenticate_publisher!
  before_filter :prevent_session_hijack
  layout 'publish'

  private

  def prevent_session_hijack
    render(:file => "#{RAILS_ROOT}/public/404.html", :status => 404) if params[:publisher_id].to_i != current_publisher.id
  end
end
