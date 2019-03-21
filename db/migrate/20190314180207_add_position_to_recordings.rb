class AddPositionToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :position, :integer
  end
end
