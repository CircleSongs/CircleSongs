class UpdateSongComposerName < ActiveRecord::Migration[8.0]
  def change
    rename_column :songs, :composer, :composer_name
  end
end
