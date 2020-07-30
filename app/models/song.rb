class Song < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  include ImageUploader::Attachment.new(:image)

  has_many :recordings, -> { order :created_at }
  accepts_nested_attributes_for :recordings, reject_if: proc { |attributes|
    attributes['url'].blank? && attributes['embedded_player'].blank?
  }, allow_destroy: true
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :categories
  has_many :song_chord_forms
  accepts_nested_attributes_for :song_chord_forms, allow_destroy: true, reject_if: :all_blank
  has_many :chord_forms, through: :song_chord_forms
  accepts_nested_attributes_for :chord_forms, allow_destroy: true, reject_if: :all_blank

  def formatted_chords
    @formatted_chords ||= Chordpro.html(chords)
  end
end
