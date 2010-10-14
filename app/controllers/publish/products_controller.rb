class Publish::ProductsController < Publish::PublishController
  belongs_to :publisher do
    belongs_to :catalog, :optional => true
  end
end

