class AddReportedToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :reported, :boolean
  end
end
