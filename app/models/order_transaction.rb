class OrderTransaction < ActiveRecord::Base
  belongs_to :order

  # just to persist ActiveMerchant responses to db
  def response=(response)
    self.success       = response.success?
    self.authorization = response.authorization
    self.message       = response.message
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success       = false
    self.authorization = nil
    self.message       = e.message
  end
end

