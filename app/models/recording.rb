class Recording < ApplicationRecord
  belongs_to :song

  validates :url, presence: { unless: proc { |recording| recording.embedded_player.present? } }
  validates :embedded_player, presence: { unless: proc { |recording| recording.url.present? } }

  default_scope { order(:position) }

    def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "embedded_player", "id", "position", "reported", "song_id", "title", "updated_at", "url"]
  end
end
