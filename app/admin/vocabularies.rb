ActiveAdmin.register Vocabulary do
  menu parent: "Site", priority: 2, label: "Quechua"

  filter :text
  filter :translation

  permit_params :text, :translation

  index do
    column :text
    column :translation
    column "Created", sortable: :created_at do |vocabulary|
      safe_join([vocabulary.created_at.strftime("%-m/%-d/%y"), vocabulary.created_at.strftime("%-l:%M%P").strip], tag.br)
    end
    column "Updated", sortable: :updated_at do |vocabulary|
      safe_join([vocabulary.updated_at.strftime("%-m/%-d/%y"), vocabulary.updated_at.strftime("%-l:%M%P").strip], tag.br)
    end
    actions
  end
end
