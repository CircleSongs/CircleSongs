class AddPositionToLanguages < ActiveRecord::Migration[8.1]
  def change
    add_column :languages, :position, :integer

    Language.order(:name).each.with_index(1) { |l, i| l.update_column(:position, i) }
  end
end
