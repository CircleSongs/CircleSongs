class AddImageDataToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :image_data, :text
  end
end
