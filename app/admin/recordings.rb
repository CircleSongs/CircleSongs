ActiveAdmin.register Recording do
  include TrackableShow
  menu priority: 2

  permit_params :title, :song_id, :external_media_url

  filter :title
  filter :song_title_cont, label: "Song Title"

  index do
    column :title, sortable: true do |recording|
      link_to recording.title, admin_recording_path(recording)
    end
    column :song, sortable: 'songs.title' do |recording|
      link_to recording.song.title, admin_song_path(recording.song) if recording.song
    end
    column :position, sortable: true
    column "Created", sortable: :created_at do |recording|
      admin_date(recording.created_at)
    end
    column "Updated", sortable: :updated_at do |recording|
      admin_date(recording.updated_at)
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :song, collection: Song.order(:title).map { |s| [s.title, s.id] },
                     input_html: { class: 'tom-select' }
      f.input :title
      f.input :external_media_url, hint: "Supported: SoundCloud, YouTube, Spotify URLs. For Bandcamp, paste the embed URL from the embed code."
    end
    f.actions
  end

  show do
    attributes_table do
      row :song do |recording|
        link_to recording.song.title, admin_song_path(recording.song) if recording.song
      end
      row :title
      row :player do |recording|
        if recording.source.present?
          render "recordings/players/#{recording.source}", recording: recording
        else
          "No player available"
        end
      end
      row :position
    end
  end

  controller do
    def scoped_collection
      super.joins(:song)
    end
  end
end
