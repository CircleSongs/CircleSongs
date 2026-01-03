class AddExternalMediaUrlToRecordings < ActiveRecord::Migration[8.1]
  def change
    add_column :recordings, :external_media_url, :string
  end
end
