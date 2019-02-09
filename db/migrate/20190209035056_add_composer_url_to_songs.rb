class AddComposerUrlToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :composer_url, :string
  end
end
