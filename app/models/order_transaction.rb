class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  serialize :params

  class << self

    def purchase(amount, credit_card, options)
      transaction_for :purchase, amount do
        GATEWAY.purchase(amount, credit_card, options)
      end
    end

    def authorize(amount, credit_card, options)
      transaction_for :authorize, amount do
        GATEWAY.authorize(amount, credit_card, options)
      end
    end

    def capture(amount, authorization, options={})
      # "authorization" is actually "order_id" (see ActiveMerchant::Billing::LinkpointGateway)
      transaction_for :capture, amount do
        GATEWAY.capture(amount, authorization, options)
      end
    end

    private

    def transaction_for(action,amount)
      result = new
      result.action = action.to_s
      result.amount = amount
      response = yield
      begin
        result.success       = response.success?
        result.authorization = response.authorization
        result.message       = response.message
        result.test          = response.test?
        result.params        = response.params
      rescue ActiveMerchant::ActiveMerchantError => e
        result.success       = false
        result.authorization = nil
        result.message       = e.message
        result.test          = GATEWAY.test?
        result.params        = {}
      end
      result
    end
  end
end

