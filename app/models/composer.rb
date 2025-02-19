class Composer < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :songs, dependent: :nullify

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id id_value name updated_at url]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[songs]
  end
end
