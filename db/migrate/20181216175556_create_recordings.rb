class CreateRecordings < ActiveRecord::Migration[5.2]
  def change
    create_table :recordings, id: :uuid do |t|
      t.string :title
      t.text :description
      t.string :url
      t.uuid :song_id

      t.timestamps
    end
  end
end
