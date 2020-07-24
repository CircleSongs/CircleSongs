class CreateVocabularies < ActiveRecord::Migration[6.0]
  def change
    create_table :vocabularies, id: :uuid do |t|
      t.string :text
      t.string :translation

      t.timestamps
    end
  end
end
