class Admin < ActiveRecord::Base
  validates_presence_of :email

  devise :database_authenticatable, :rememberable, :timeoutable, :trackable
end

