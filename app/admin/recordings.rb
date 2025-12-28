ActiveAdmin.register Recording do
  permit_params :title, :url, :embedded_player, :description, :reported, :song_id, :position

  filter :title
  filter :url
  filter :description
  filter :reported, as: :boolean
  filter :song_title_cont, label: "Song Title"
  filter :created_at
  filter :updated_at

  index do
    column :title, sortable: true
    column :song, sortable: 'songs.title' do |recording|
      link_to recording.song.title, admin_song_path(recording.song) if recording.song
    end
    column :url do |recording|
      link_to recording.url, recording.url, target: '_blank', rel: 'noopener' if recording.url.present?
    end
    column :reported, sortable: true
    column :position, sortable: true
    actions
  end

  form do |f|
    f.inputs do
      f.input :song, collection: Song.order(:title).map { |s| [s.title, s.id] },
                     input_html: { class: 'tom-select' }
      f.input :title
      f.input :url
      f.input :embedded_player, input_html: { rows: 5 }
      f.input :description, input_html: { rows: 5 }
      f.input :position
      f.input :reported
    end
    f.actions
  end

  show do
    attributes_table do
      row :song do |recording|
        link_to recording.song.title, admin_song_path(recording.song) if recording.song
      end
      row :title
      row :url do |recording|
        link_to recording.url, recording.url, target: '_blank', rel: 'noopener' if recording.url.present?
      end
      row :embedded_player do |recording|
        raw recording.embedded_player if recording.embedded_player.present?
      end
      row :description do
        simple_format recording.description
      end
      row :position
      row :reported
      row :created_at
      row :updated_at
    end
  end

  controller do
    def scoped_collection
      super.joins(:song)
    end
  end
end
