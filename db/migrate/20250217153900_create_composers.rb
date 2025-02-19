class CreateComposers < ActiveRecord::Migration[8.0]
  def change
    create_table :composers, id: :uuid do |t|
      t.string :name
      t.string :url
      t.text :description
      t.integer :songs_count, default: 0, null: false
      t.timestamps
    end
  end
end
