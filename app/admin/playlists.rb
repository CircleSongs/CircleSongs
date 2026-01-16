ActiveAdmin.register Playlist do
  permit_params :title, :description, :url

  index do
    column :title
    column :description
    column :url
    column :created_at
    column :updated_at
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
