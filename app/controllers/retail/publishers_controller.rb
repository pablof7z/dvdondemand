class Retail::PublishersController < Retail::RetailController
  actions :index, :show

  def show
    show! do
      render(:text => 'Forbidden', :status => 403) and return unless @publisher.approved
    end
  end

  protected

  def collection
    # by default, only show approved Publishers
    @publishers = Publisher.approved
  end
end

