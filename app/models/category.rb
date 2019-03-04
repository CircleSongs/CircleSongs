class Category < ApplicationRecord
  has_and_belongs_to_many :songs

  validates :name, uniqueness: true

  scope :unrestricted, -> { where restricted: [false, nil] }
  scope :restricted, -> { where restricted: true }

  def name_and_count
    str = "#{name} (#{songs.count})"
  end
end
