class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name

      t.timestamps
    end

    create_table :categories_songs, id: :uuid do |t|
      t.uuid :category_id
      t.uuid :song_id
    end
  end
end
