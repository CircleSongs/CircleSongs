class CreateChordForms < ActiveRecord::Migration[6.0]
  def change
    remove_column :songs, :chord_forms, :text
    create_table :chord_forms, id: :uuid do |t|
      t.string :chord
      t.text :fingering
    end

    create_table :song_chord_forms, id: :uuid do |t|
      t.uuid :song_id
      t.uuid :chord_form_id
      t.integer :position
    end
  end
end
