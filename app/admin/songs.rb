ActiveAdmin.register Song do

  permit_params :title, :alternate_title, :composer, :lyrics, :translation,
                :chords, song_links_attributes: [:title, :url]

  index do
    column :title
    column :composer
    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :alternate_title
      f.input :composer
      f.input :lyrics
      f.input :translation
      f.input :chords
    end
    f.inputs do
      f.has_many :song_links, heading: 'Links',
          allow_destroy: true,
      new_record: true do |a|
        a.input :title
        a.input :url
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :title
      row :alternate_title
      row :composer
      row :lyrics do
        simple_format song.lyrics
      end
      row :translation do
        simple_format song.translation
      end
      row :chords do
        div class: :chordpro do
          raw song.formatted_chords
        end
      end
    end
    panel "Links" do
      table_for song.song_links do
        column :title
        column :url
      end
    end
  end

end
