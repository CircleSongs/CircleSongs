ActiveAdmin.register Language do
  menu parent: "Taxonomy", priority: 2

  permit_params :name

  index do
    column :name
    actions
  end
end
