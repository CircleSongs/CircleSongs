class CreateSongLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :song_links, id: :uuid do |t|
      t.string :source
      t.string :url
      t.uuid :song_id

      t.timestamps
    end
  end
end
