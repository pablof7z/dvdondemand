class FeeVersion < ActiveRecord::Base
  belongs_to :sale
  belongs_to :fee
end
