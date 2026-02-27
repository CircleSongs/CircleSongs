ActiveAdmin.register Category do
  menu parent: "Taxonomy", priority: 1

  include SortableIndex
  config.sort_order = "position_asc"
  config.paginate = false

  permit_params :name, :restricted, :description, :position

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, as: :text
      f.input :restricted
    end
    f.actions
  end

  index as: :table do
    column("", class: "handle") { "☰" }
    column :name
    column :description
    column :restricted do |category|
      if category.restricted?
        span class: "status_tag yes" do
          "Yes"
        end
      end
    end
    actions
  end
end
