class AddPositionToCategoriesAndPlaylists < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :position, :integer
    add_column :playlists, :position, :integer

    Category.order(:name).each.with_index(1) { |c, i| c.update_column(:position, i) }
    Playlist.order(:title).each.with_index(1) { |p, i| p.update_column(:position, i) }
  end
end
