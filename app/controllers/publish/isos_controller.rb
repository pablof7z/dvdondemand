class Publish::IsosController < Publish::PublishController
  belongs_to :product
  actions :create, :show
  respond_to :json, :only => :create
  respond_to :js, :only => :show

  def create
    create! do |success, failure|
      success.json { render :json => { :result => 'success', :source => publish_product_iso_path(@iso.product, @iso, :format => :js) } }
      failure.json { render :json => { :result => 'error' } } # not yet actually handled in Uploadify's onComplete event
    end
  end
end

