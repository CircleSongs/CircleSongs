ActiveAdmin.register ActsAsTaggableOn::Tag, as: "Tag" do
  menu label: "Tags (Themes)"

  permit_params :name

  filter :name

  index do
    selectable_column
    column :name
    column "Usage Count", sortable: :taggings_count do |tag|
      tag.taggings_count
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row("Usage Count") { |tag| tag.taggings_count }
    end

    panel "Songs with this tag" do
      songs = Song.tagged_with(resource.name, on: :themes)
      if songs.any?
        table_for songs do
          column :title do |song|
            link_to song.title, admin_song_path(song)
          end
          column :composer
        end
      else
        para "No songs are using this tag."
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
