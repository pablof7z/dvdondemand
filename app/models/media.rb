class Media < ActiveRecord::Base
  has_one :cover_art
  has_and_belongs_to_many :catalog_media
end
