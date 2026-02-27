ActiveAdmin.register Vocabulary do
  menu parent: "Site", priority: 2, label: "Quechua"

  filter :text
  filter :translation

  permit_params :text, :translation

  index do
    column :text
    column :translation
    column :created_at
    column :updated_at
    actions
  end
end
