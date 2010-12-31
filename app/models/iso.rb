class Iso < ActiveRecord::Base
  belongs_to :product

  has_attached_file :iso, :path => ':rails_root/public/system/:id/disc.iso'
end

