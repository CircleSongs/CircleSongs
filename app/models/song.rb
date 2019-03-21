class Song < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  has_many :recordings
  accepts_nested_attributes_for :recordings, reject_if: proc { |attributes|
    attributes['url'].blank? && attributes['embedded_player'].blank?
  }, allow_destroy: true
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :categories

  def formatted_chords
    @formatted_chords ||= Chordpro.html(chords)
  end
end
