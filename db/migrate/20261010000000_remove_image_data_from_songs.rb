class RemoveImageDataFromSongs < ActiveRecord::Migration[8.1]
  def change
    safety_assured { remove_column :songs, :image_data, :text }
  end
end
