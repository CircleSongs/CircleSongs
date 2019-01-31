class CreateLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :languages, id: :uuid do |t|
      t.string :name

      t.timestamps
    end

    create_table :languages_songs, id: :uuid do |t|
      t.uuid :language_id
      t.uuid :song_id
    end
  end
end
