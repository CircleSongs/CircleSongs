ActiveAdmin.register Language do
  menu parent: "Taxonomy", priority: 2

  permit_params :name

  index do
    column :name
    column "Songs" do |language|
      link_to language.songs.size, admin_songs_path(q: { languages_id_in: [language.id] })
    end
    actions
  end
end
