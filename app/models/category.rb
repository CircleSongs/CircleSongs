class Category < ApplicationRecord
  has_and_belongs_to_many :songs

  validates :name, uniqueness: true

  scope :unrestricted, -> { where restricted: [false, nil] }
  scope :restricted, -> { where restricted: true }

  def name_and_count
    "#{name} (#{songs.count})"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "restricted", "updated_at"]
  end

    def self.ransackable_associations(auth_object = nil)
    ["songs"]
  end
end
