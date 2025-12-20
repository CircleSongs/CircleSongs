# frozen_string_literal: true

class CreateActsAsTaggableOnTables < ActiveRecord::Migration[7.0]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :name, null: false
      t.integer :taggings_count, default: 0, null: false
      t.timestamps
    end

    create_table :taggings, id: :uuid do |t|
      t.references :tag, type: :uuid, foreign_key: true
      t.references :taggable, polymorphic: true, type: :uuid
      t.references :tagger, polymorphic: true, type: :uuid
      t.string :context, limit: 128
      t.datetime :created_at
    end

    add_index :taggings, [:taggable_type, :taggable_id]
    add_index :taggings, [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
              unique: true, name: 'taggings_idx'
    add_index :tags, :name, unique: true
  end
end
