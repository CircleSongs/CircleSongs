class ChordForm < ApplicationRecord
  has_many :song_chord_forms
  has_many :songs, through: :song_chord_forms

  validates :chord, presence: true
  validates :fingering, presence: true
  validate :fingering_must_be_json

    def self.ransackable_attributes(auth_object = nil)
    ["chord", "fingering", "id"]
  end

    def self.ransackable_associations(auth_object = nil)
    ["song_chord_forms", "songs"]
  end

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
