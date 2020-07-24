ActiveAdmin.register Vocabulary do
  menu label: 'Quechua'

  permit_params :text, :translation

  index do
    column :text
    column :translation
    column :created_at
    column :updated_at
    actions
  end
end
