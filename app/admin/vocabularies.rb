ActiveAdmin.register Vocabulary do
  include TrackableShow
  menu parent: "Site", priority: 2, label: "Quechua"

  filter :text
  filter :translation

  permit_params :text, :translation

  index do
    column :text
    column :translation
    column "Created", sortable: :created_at do |vocabulary|
      admin_date(vocabulary.created_at)
    end
    column "Updated", sortable: :updated_at do |vocabulary|
      admin_date(vocabulary.updated_at)
    end
    actions
  end
end
