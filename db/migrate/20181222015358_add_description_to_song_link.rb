class AddDescriptionToSongLink < ActiveRecord::Migration[5.2]
  def change
    add_column :song_links, :description, :text
  end
end
