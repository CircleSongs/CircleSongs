class AddTrackingColumnsToModels < ActiveRecord::Migration[8.1]
  def change
    tables = %i[songs recordings categories languages playlists composers chord_forms vocabularies passwords]

    tables.each do |table|
      safety_assured do
        add_column table, :created_by_id, :uuid
        add_column table, :updated_by_id, :uuid
        add_foreign_key table, :users, column: :created_by_id
        add_foreign_key table, :users, column: :updated_by_id
      end
    end
  end
end
