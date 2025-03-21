ActiveAdmin.register Recording do
  permit_params :title, :description, :url, :embedded_player, :reported, :song_id, :position

  filter :title_cont
  filter :description_cont
  filter :url_cont
  filter :song_title_cont, label: "Song Title"
  filter :reported
  index do
    column :title
    column :description
    column :url do |recording|
      link_to recording.url, recording.url, target: :_blank, rel: :noopener
    end
    column :embedded_player do |recording|
      recording.embedded_player.present?
    end
    column :song do |recording|
      link_to recording.song.title, admin_song_path(recording.song) if recording.song.present?
    end
    column :created_at
    column :updated_at
    column :reported
    actions
  end
end
