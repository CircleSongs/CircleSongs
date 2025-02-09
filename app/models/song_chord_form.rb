class SongChordForm < ApplicationRecord
  belongs_to :song
  belongs_to :chord_form

    def self.ransackable_attributes(auth_object = nil)
    ["chord_form_id", "id", "id_value", "position", "song_id"]
  end
end
