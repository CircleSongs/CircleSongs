class Vocabulary < ApplicationRecord
  validates :text, presence: true
  validates :translation, presence: true

  scope :alphabetical, -> { order("unaccent(text)") }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value text translation updated_at]
  end
end
