class Publish::IsosController < Publish::PublishController
  belongs_to :product
  actions :create, :destroy
  respond_to :json
end

