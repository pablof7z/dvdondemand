class Publish::SalesController < PublishController
  belongs_to :publisher
  actions :index, :show

  protected

  def collection
    @sales ||= end_of_association_chain.group_by { |s| s.created_at.beginning_of_month  }
  end
end

