class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments, id: :uuid do |t|
      t.string :body
      t.string :commentable_type
      t.uuid :commentable_id

      t.timestamps
    end
  end
end
