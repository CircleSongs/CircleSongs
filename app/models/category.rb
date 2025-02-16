class Category < ApplicationRecord
  has_and_belongs_to_many :songs

  validates :name, uniqueness: true

  scope :unrestricted, -> { where restricted: [false, nil] }
  scope :restricted, -> { where restricted: true }

  def name_and_count
    "#{name} (#{songs.count})"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value name restricted updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["songs"]
  end
end
