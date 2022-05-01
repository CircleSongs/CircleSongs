ActiveAdmin.register Song do
  filter :title
  filter :alternate_title
  filter :languages, multiple: true
  filter :categories, multiple: true
  filter :chords_present, as: :boolean
  filter :chord_forms_id_not_null, label: "With Chord forms", as: :boolean
  filter :lyrics
  filter :translation
  filter :description
  filter :composer_url
  filter :slug
  filter :recordings_reported, as: :boolean, label: "Broken Link Reported"


  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  permit_params :alternate_title, :composer, :composer_url, :image,
                :description, :lyrics, :title, :translation,
                :chords,
                recordings_attributes: [
                  :description,
                  :embedded_player,
                  :title,
                  :url,
                  :id,
                  :position,
                  :reported,
                  :_destroy
                ],
                song_chord_forms_attributes: [:id, :chord_form_id, :_destroy, :position],
                category_ids: [],
                language_ids: []

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
      f.inputs do
        f.has_many(
          :song_chord_forms,
          sortable: :position,
          sortable_start: 1,
          new_record: 'Add new chord form',
          allow_destroy: true
        ) do |cf|
          cf.input :chord_form, collection: ChordForm.all.map { |chord_form|
            [chord_form.chord, chord_form.id]
          }, allow_blank: true
        end
      end
      f.input :languages, as: :check_boxes
      li class: 'check_boxes input optional', id: :song_categories_input do
        fieldset class: :choices do
          legend class: :label do
            'Categories'
          end
          ol class: 'choices-group' do
            f.collection_check_boxes :category_ids, Category.all, :id, :name do |c|
              li class: "choice #{'restricted' if c.object.restricted?}" do
                c.label { c.check_box + c.text }
              end
            end
          end
        end
      end
    end

    f.inputs do
      f.has_many(
        :recordings,
        heading: 'Recordings',
        allow_destroy: true,
        new_record: true,
        sortable: :position
      ) do |a|
        a.input :title
        a.input :url
        a.input :embedded_player
        a.input :description
        a.input :reported
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row 'Preview Link' do |song|
        link_to 'Preview', song_path(song), target: :_blank
      end
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
        simple_format song.lyrics, {}, sanitize: false
      end
      row :translation do
        simple_format song.translation, {}, sanitize: false
      end
      row :chords do |song|
        div do
          pre do
            div id: 'song-chords', data: song.chords.to_json
          end
        end
      end
      table_for song.chord_forms.order(:position) do
        column :chord
        column :fingering do |chord_form|
          div class: 'chord-form', 'data-fingering': chord_form.fingering
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
        column :reported
      end
    end
  end
end
