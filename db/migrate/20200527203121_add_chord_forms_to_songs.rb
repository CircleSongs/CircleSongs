class AddChordFormsToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :chord_forms, :text
  end
end
