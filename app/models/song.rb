class Song < ApplicationRecord
  has_many :song_links
  accepts_nested_attributes_for :song_links
end
