class Publisher < ActiveRecord::Base
  has_many :catalogs, :dependent => :delete_all
  has_many :products
  has_many :items
  has_many :sales
  has_many :publisher_payments

  def full_name
    "#{first_name} #{last_name}"
  end
end
