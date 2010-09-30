class PublisherPayment < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :sale
end
