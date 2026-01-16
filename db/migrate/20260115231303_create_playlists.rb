class CreatePlaylists < ActiveRecord::Migration[8.1]
  def change
    create_table :playlists, id: :uuid do |t|
      t.string :title
      t.text :description
      t.string :url


      t.timestamps
    end
  end
end
