class AddProtectedToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :protected, :boolean, default: false
  end
end
