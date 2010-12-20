class Publish::CatalogsController < PublishController
  belongs_to :publisher
  
  def create
    create! do |success, failure|
      success.html { redirect_to publish_publisher_catalogs_path(current_publisher) }
    end
  end

  protected

  def collection
    @catalogs = current_publisher.catalogs
  end
end

