class Publish::SalesController < PublishController
  belongs_to :publisher
  actions :index, :show
end

