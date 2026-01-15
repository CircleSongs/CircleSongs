class AddFeaturedToSongs < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!
  def change
    add_column :songs, :featured, :boolean, null: false, default: false
    add_index :songs, :featured, where: 'featured', algorithm: :concurrently
  end
end
