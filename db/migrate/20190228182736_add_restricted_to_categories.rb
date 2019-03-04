class AddRestrictedToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :restricted, :boolean, default: false
  end
end
