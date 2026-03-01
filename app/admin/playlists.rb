ActiveAdmin.register Playlist do
  include TrackableShow
  menu priority: 5

  include SortableIndex
  config.sort_order = "position_asc"
  config.paginate = false
  permit_params :title, :description, :url

  index as: :table do
    column("", class: "handle") { "☰" }
    column :title do |playlist|
      link_to playlist.title, admin_playlist_path(playlist)
    end
    column :description
    column :url do |playlist|
      if playlist.url.present?
        link_to "#{playlist.url} #{content_tag(:i, nil, class: 'fa-solid fa-arrow-up-right-from-square')}".html_safe, playlist.url, target: :_blank, rel: :noopener
      end
    end
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
        if playlist.url.present?
          link_to "#{playlist.url} #{content_tag(:i, nil, class: 'fa-solid fa-arrow-up-right-from-square')}".html_safe, playlist.url, target: :_blank, rel: :noopener
        end
      end
      row :created_at
      row :updated_at
    end
  end
end
