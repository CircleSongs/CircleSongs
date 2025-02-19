class AddComposerIdToSongs < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_reference :songs, :composer, null: true, type: :uuid, index: {algorithm: :concurrently}
  end
end
