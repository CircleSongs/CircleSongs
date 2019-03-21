ActiveAdmin.register Song do
  permit_params :alternate_title, :composer, :composer_url, :image,
                :description, :lyrics, :title, :translation,
                :chords, recordings_attributes: [
                  :description, :embedded_player, :title, :url, :id, :_destroy
                ], category_ids: [], language_ids: []

  index do
    column :title
    column :composer
    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :image, as: :file
      f.input :title
      f.input :alternate_title
      f.input :composer
      f.input :composer_url
      f.input :description
      f.input :lyrics
      f.input :translation
      f.input :chords
      f.input :languages, as: :check_boxes
      li class: 'check_boxes input optional', id: :song_categories_input do
        fieldset class: :choices do
          legend class: :label do
            'Categories'
          end
          ol class: 'choices-group' do
            f.collection_check_boxes :category_ids, Category.all, :id, :name do |c|
              li class: "choice #{'restricted' if c.object.restricted? }" do
                c.label { c.check_box + c.text}
              end
            end
          end
        end
      end
    end

    f.inputs do
      f.has_many :recordings, heading: 'Recordings', allow_destroy: true, new_record: true do |a|
        a.input :title
        a.input :url
        a.input :embedded_player
        a.input :description
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :image do |song|
        image_tag song.image[:thumb].url if song.image.present?
      end
      row :title
      row :alternate_title
      row :composer do |song|
        link_to song.composer, song.composer_url, target: :_blank
      end
      row :description do
        simple_format song.description
      end
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
        column :url do |recording|
          link_to recording.url, recording.url, target: :_blank
        end
        column :embedded_player do |recording|
          raw recording.embedded_player
        end
        column :description
      end
    end
  end

end
