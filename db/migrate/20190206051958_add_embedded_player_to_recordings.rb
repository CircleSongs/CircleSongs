class AddEmbeddedPlayerToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :embedded_player, :text
  end
end
