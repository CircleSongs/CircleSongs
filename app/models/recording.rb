class Recording < ApplicationRecord
  belongs_to :song

  validates :url, presence: { unless: Proc.new { |recording| recording.embedded_player.present? } }
  validates :embedded_player, presence: { unless: Proc.new { |recording| recording.url.present? } }

  default_scope { order(:position) }
end
