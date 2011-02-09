class CreditCard < ActiveRecord::Base
  belongs_to :wholesaler
  
  validates_presence_of :card_type, :card_number, :card_verification_value, :card_expires_on, :address1, :city, :state, :zip, :country
  
  def after_create
    if wholesaler
      wholesaler.credit_cards.each { |i| return if i.default }
      self.default = true
      self.save
    end
  end
  
  def card_number_mask
    last_part = card_number[card_number.size-4, 4]
    first_part = card_number[0, card_number.size-4].gsub(/[0-9]/, 'X')
    "#{first_part}#{last_part}"
  end
end
