class Admin < ActiveRecord::Base
  validates_presence_of :email
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i

  devise :database_authenticatable, :rememberable, :timeoutable, :trackable
end

