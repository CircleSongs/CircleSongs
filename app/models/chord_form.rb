class ChordForm < ApplicationRecord
  has_many :song_chord_forms
  has_many :songs, through: :song_chord_forms

  validates :chord, presence: true
  validates :fingering, presence: true
  validate :fingering_must_be_json

  private

  def fingering_must_be_json
    return unless fingering.present?

    begin
      JSON.parse fingering
    rescue JSON::ParserError
      errors.add(:fingering, 'must be valid JSON')
    end
  end
end
