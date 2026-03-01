class ChordForm < ApplicationRecord
  include Trackable

  has_many :song_chord_forms
  has_many :songs, through: :song_chord_forms

  validates :chord, presence: true
  validates :fingering, presence: true
  validate :fingering_must_be_json

  def self.ransackable_attributes(_auth_object = nil)
    %w[chord fingering id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[song_chord_forms songs]
  end

  private

  def fingering_must_be_json
    return if fingering.blank?

    begin
      JSON.parse fingering
    rescue JSON::ParserError
      errors.add(:fingering, "must be valid JSON")
    end
  end
end
