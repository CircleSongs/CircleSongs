ActiveAdmin.register Playlist do
  menu priority: 5

  include SortableIndex
  config.sort_order = "position_asc"
  config.paginate = false
  permit_params :title, :description, :url

  index as: :table do
    column("", class: "handle") { "☰" }
    column :title
    column :description
    column :url
    actions
  end

  form do |f|
    f.inputs "Playlist Details" do
      f.input :title
      f.input :description, input_html: { rows: 3 }
      f.input :url, hint: "Must be from Spotify, YouTube, SoundCloud, or Bandcamp"
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :url do |playlist|
        link_to playlist.url, playlist.url, target: :_blank, rel: :noopener
      end
      row :created_at
      row :updated_at
    end
  end
end
