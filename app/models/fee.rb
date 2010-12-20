class Fee < ActiveRecord::Base
  validates_presence_of :description, :amount
end
