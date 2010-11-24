class Publish::CatalogsController < PublishController
  belongs_to :publisher

  protected

  def collection
    @catalogs = current_publisher.catalogs
  end
end

