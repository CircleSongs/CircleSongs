class ConvertFriendlyIdSlugsToUuid < ActiveRecord::Migration[8.1]
  # The table was created with an integer sluggable_id, which cannot point at
  # our UUID records, so any rows in it are unusable and are dropped. The table
  # is small and only read on a slug miss, so rewriting it in place is safe.
  def up
    safety_assured do
      execute "DELETE FROM friendly_id_slugs"
      remove_index :friendly_id_slugs, %i[sluggable_type sluggable_id]
      remove_column :friendly_id_slugs, :sluggable_id
      add_column :friendly_id_slugs, :sluggable_id, :uuid, null: false # rubocop:disable Rails/NotNullColumn
      add_index :friendly_id_slugs, %i[sluggable_type sluggable_id]

      # Record every song's current slug so it keeps resolving after a rename.
      execute <<~SQL.squish
        INSERT INTO friendly_id_slugs (slug, sluggable_id, sluggable_type, created_at)
        SELECT slug, id, 'Song', NOW() FROM songs WHERE slug IS NOT NULL
      SQL
    end
  end

  def down
    safety_assured do
      execute "DELETE FROM friendly_id_slugs"
      remove_index :friendly_id_slugs, %i[sluggable_type sluggable_id]
      remove_column :friendly_id_slugs, :sluggable_id
      add_column :friendly_id_slugs, :sluggable_id, :integer, null: false # rubocop:disable Rails/NotNullColumn
      add_index :friendly_id_slugs, %i[sluggable_type sluggable_id]
    end
  end
end
