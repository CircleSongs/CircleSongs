class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments, id: :uuid do |t|
      t.string :body
      t.references :comentable, polymorphic: true

      t.timestamps
    end
  end
end
