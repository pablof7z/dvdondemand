class Order < ActiveRecord::Base
  belongs_to :sale
  belongs_to :customer
  belongs_to :shipping_option # USPS, FedEx, DHL, etc.
  has_many :customer_payments

  has_many :items, :class_name => 'OrderItem', :dependent => :delete_all
  accepts_nested_attributes_for :items

  has_many :transactions, :class_name => 'OrderTransaction', :dependent => :delete_all
  attr_accessor :card_number, :card_verification  # to not persist'em in the db
  attr_accessor :first_name, :last_name           # just for credit_card validations

  validate_on_create :valid_credit_card

  def items_full_count
    items.sum(:quantity)
  end

  def total
    total = 0
    total = items.inject(0) do |subtotal, item|
      subtotal + item.product.price * item.quantity + item.packaging_option.price
    end
    total
  end

  def billing_address
    address_for :billing
  end

  def shipping_address
    address_for :shipping
  end

  # follow ActiveMerchant-specific methods for FirstData integration

  # all amounts should be in cents to prevent rounding
  def total_in_cents
    (total*100).round
  end

  def purchase
    response = GATEWAY.purchase(total_in_cents, credit_card, options)
    transactions.create!(:action => 'purchase', :amount => total_in_cents, :response => response)
    response.success?
  end

  private

  def valid_credit_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :first_name         => first_name,
      :last_name          => last_name,
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year
    )
  end

  # full parameters documented in ActiveMerchant's billing/gateways/linkpoint.rb file
  def options
    {
      :billing_address => {
        :name     => customer.full_name,
        :address1 => billing_address1,
        :address2 => billing_address2,
        :city     => billing_city,
        :state    => billing_state,
        :zip      => billing_zip_code,
        :country  => billing_country,
        :company  => customer.company,   # same as Customer's?
        :email    => customer.email      # same as Customer's?
      },
      :shipping_address => {
        :name     => shipping_name,
        :address1 => shipping_address1,
        :address2 => shipping_address2,
        :city     => shipping_city,
        :state    => shipping_state,
        :zip      => shipping_zip_code,
        :country  => shipping_country
      },
      :order_id => id,
      :email    => customer.email,
      :ip       => ip_address
    }
  end

  # build composite address for billing/shipping
  def address_for(where)
    returning address = [] do 
      address << send("#{where.to_s}_address1")
      address << send("#{where.to_s}_address2") unless send("#{where.to_s}_address2").blank?
      address << send("#{where.to_s}_city")     unless send("#{where.to_s}_city").blank?
      address << send("#{where.to_s}_state")    unless send("#{where.to_s}_state").blank?
      address << send("#{where.to_s}_country")  unless send("#{where.to_s}_country").blank?
    end
    address.join('<br />')
  end
end

