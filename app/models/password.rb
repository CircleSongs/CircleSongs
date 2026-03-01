class Password < ApplicationRecord
  include Trackable

  validates :name, presence: true
  validates :value, presence: true

  def self.restricted_songs
    find_by!(name: "Restricted Songs").value
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value name updated_at value]
  end
end
