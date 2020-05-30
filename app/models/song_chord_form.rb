class SongChordForm < ApplicationRecord
  belongs_to :song
  belongs_to :chord_form
end
