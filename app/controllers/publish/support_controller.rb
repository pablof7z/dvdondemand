class Publish::SupportController < PublishController
  skip_before_filter :authenticate_publisher!, :only => :terms

  def terms
    @publisher_name, @publisher_address = if publisher_signed_in?
      full_address = "#{current_publisher.address1} #{current_publisher.address2}" +
        "#{current_publisher.city} #{current_publisher.state} " +
        "#{current_publisher.zip_code} #{current_publisher.country}"
      [ current_publisher.full_name,
        full_address !~ /^\s+$/ ? full_address : nil ]
    else
      [ 'The Publisher', nil ]
    end
  end
end
