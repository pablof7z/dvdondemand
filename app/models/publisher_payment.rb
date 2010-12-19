class PublisherPayment < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :sale
  belongs_to :bank_information
end
