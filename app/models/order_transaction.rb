class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  serialize :params

  # just to persist ActiveMerchant responses to db
  def response=(response)
    self.success       = response.success?
    self.authorization = response.authorization
    self.message       = response.message
    self.test          = response.test?
    self.params        = response.params
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success       = false
    self.authorization = nil
    self.message       = e.message
    self.test          = GATEWAY.test?
    self.params        = {}
  end
end

