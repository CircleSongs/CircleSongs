class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs, id: :uuid do |t|
      t.string :title
      t.string :alternate_title
      t.string :composer
      t.text   :lyrics
      t.text   :translation
      t.text   :chords
      t.timestamps
    end
  end
end
