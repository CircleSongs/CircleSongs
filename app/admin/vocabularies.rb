ActiveAdmin.register Vocabulary do
  menu parent: "Site", priority: 2, label: "Quechua"

  filter :text
  filter :translation

  permit_params :text, :translation

  index do
    column :text
    column :translation
    column "Created", sortable: :created_at do |vocabulary|
      vocabulary.created_at.strftime("%-m/%-d/%y %-l:%M%P")
    end
    column "Updated", sortable: :updated_at do |vocabulary|
      vocabulary.updated_at.strftime("%-m/%-d/%y %-l:%M%P")
    end
    actions
  end
end
