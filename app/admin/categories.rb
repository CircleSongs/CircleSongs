ActiveAdmin.register Category do
  include SortableIndex
  config.sort_order = "position_asc"
  config.paginate = false

  permit_params :name, :restricted, :description, :position

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
