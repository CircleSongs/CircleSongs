class Password < ApplicationRecord
  validates :name, presence: true
  validates :value, presence: true

  def self.restricted_songs
    find_by!(name: 'Restricted Songs').value
  end
end
