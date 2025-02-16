class Password < ApplicationRecord
  validates :name, presence: true
  validates :value, presence: true

  def self.restricted_songs
    find_by!(name: 'Restricted Songs').value
  end

    def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at", "value"]
  end
end
