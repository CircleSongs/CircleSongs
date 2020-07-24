class Vocabulary < ApplicationRecord
  validates :text, presence: true
  validates :translation, presence: true

  scope :alphabetical, -> { order('unaccent(text)') }
end
