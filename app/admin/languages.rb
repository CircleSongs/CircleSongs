ActiveAdmin.register Language do
  include TrackableShow
  menu parent: "Taxonomy", priority: 2

  include SortableIndex
  config.sort_order = "position_asc"
  config.paginate = false

  permit_params :name, :position

  index as: :table do
    column("", class: "handle") { "☰" }
    column :name do |language|
      link_to language.name, admin_language_path(language)
    end
    column "Songs" do |language|
      link_to language.songs.size, admin_songs_path(q: { languages_id_in: [language.id] })
    end
    actions
  end
end
