class Song < ApplicationRecord
  has_many :song_links
  accepts_nested_attributes_for :song_links
  has_and_belongs_to_many :categories

  def formatted_chords
    @formatted_chords ||= Chordpro.html(chords)
  end
end
