class WholesalePrice < ActiveRecord::Base
  validates_numericality_of :minimum_quantity, :greater_than => 1
  validates_numericality_of :discount_percentage, :greater_than => 0, :less_than => 100

  # set the pagination limit here, but mind the tests
  def self.per_page
    10
  end
end
