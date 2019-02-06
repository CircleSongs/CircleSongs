ActiveAdmin.register Song do

  permit_params :title, :alternate_title, :composer, :lyrics, :translation,
    :chords, recordings_attributes: [:description, :title, :url, :id, :_destroy],
    category_ids: [], language_ids: []

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
      f.input :languages, as: :check_boxes
      f.input :categories, as: :check_boxes
    end
    f.inputs do
      f.has_many :recordings, heading: 'Recordings', allow_destroy: true, new_record: true do |a|
        a.input :title
        a.input :url
        a.input :description
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
      row :chords do |song|
        div do
          pre do
            div id: 'song-chords', data: song.chords.to_json
          end
        end
      end
      row :categories do |song|
        song.categories.map(&:name).to_sentence
      end
      row :languages do |song|
        song.languages.map(&:name).to_sentence
      end
    end
    panel 'Recordings' do
      table_for song.recordings, class: :recordings do
        column :title
        column :url
        column :description
      end
    end
  end

end
