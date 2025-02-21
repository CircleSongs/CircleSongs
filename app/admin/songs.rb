ActiveAdmin.register Song do
  # Filters for index page
  filter :title
  filter :alternate_title
  filter :languages, multiple: true
  filter :categories, multiple: true
  filter :chords_present, as: :boolean
  filter :chord_forms_id_not_null, label: "With Chord forms", as: :boolean
  filter :composer_id_not_null, label: "Has Composer", as: :boolean
  filter :lyrics
  filter :translation
  filter :description
  filter :composer_name, label: "Composer name (legacy)"
  filter :slug
  filter :recordings_reported, as: :boolean, label: "Broken Link Reported"

  # Controller customization
  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def scoped_collection
      super.left_joins(:composer)
           .left_joins(:chord_forms)
           .select("songs.*, COUNT(chord_forms.id) as chord_forms_count, composers.name as composer_name")
           .group("songs.id, composers.name")
    end
  end

  # Permitted parameters
  permit_params :alternate_title, :image,
                :description, :lyrics, :title, :translation,
                :chords, :remove_image,
                :composer_id,
                recordings_attributes: %i[
                  description
                  embedded_player
                  title
                  url
                  id
                  position
                  reported
                  _destroy
                ],
                song_chord_forms_attributes: %i[id chord_form_id _destroy position],
                category_ids: [],
                language_ids: []

  # Index page configuration
  index do
    column :title, sortable: true
    column :composer, sortable: 'composers.name' do |song|
      link_to song.composer.name, song.composer.url, target: :_blank, rel: :noopener if song.composer
    end
    column "Composer (legacy)", :composer_name
    column "Has Chords", sortable: :chords do |song|
      song.chords.present? ? "Yes" : "No"
    end
    column "Has Chord Forms", :chord_forms, sortable: :chord_forms_count do |song|
      song.chord_forms.exists? ? "Yes" : "No"
    end
    actions
  end

  # Form configuration
  form do |f|
    f.inputs "Details" do
      f.input :image, as: :file,
                      hint: (image_tag f.object.image[:thumb].url if f.object.image.present?)
      f.input :remove_image, as: :boolean
      f.input :title
      f.input :alternate_title
      f.inputs "Composer" do
        f.input :composer_id, as: :select,
                              collection: Composer.order(:name).map { |c| [c.name, c.id] },
                              input_html: { class: 'chosen-select' },
                              prompt: "Existing composer",
                              hint: [
                                "Legacy composer:",
                                f.object.composer_name,
                                f.object.composer_url
                              ].join(" ").html_safe

        # f.inputs "New Composer", for: [:composer, f.object.composer || Composer.new] do |c|
        #   c.input :name, label: "New Composer name"
        #   c.input :url, label: "New Composer website"
        # end
      end
      f.input :description, input_html: { rows: 5 }
      f.input :lyrics, input_html: { rows: 5 }
      f.input :translation, input_html: { rows: 5 }
      f.input :chords, input_html: { rows: 5 }

      # Chord Forms Section
      f.inputs "Chord Forms", class: "chord-forms-section" do
        f.has_many(
          :song_chord_forms,
          sortable: :position,
          sortable_start: 1,
          new_record: "Add new chord form",
          allow_destroy: true,
          class: "chord-forms-container",
          heading: false
        ) do |cf|
          cf.input :chord_form,
                   collection: ChordForm.all.map { |chord_form| [chord_form.chord, chord_form.id] },
                   label: false,
                   allow_blank: false,
                   input_html: { class: "chord-form-select" }
        end
      end

      f.input :languages, as: :check_boxes

      # Categories Section
      li class: "check_boxes input optional", id: :song_categories_input do
        fieldset class: :choices do
          legend class: :label do
            "Categories"
          end
          ol class: "choices-group" do
            f.collection_check_boxes :category_ids, Category.all, :id, :name do |c|
              li class: "choice #{'restricted' if c.object.restricted?}" do
                c.label { c.check_box + c.text }
              end
            end
          end
        end
      end
    end

    # Recordings Section
    f.inputs do
      f.has_many(
        :recordings,
        heading: "Recordings",
        allow_destroy: true,
        new_record: true,
        sortable: :position,
        class: "recordings-container"
      ) do |a|
        a.input :title
        a.input :url
        a.input :embedded_player, input_html: { rows: 5 }
        a.input :description, input_html: { rows: 5 }
        a.input :reported
      end
    end

    f.actions
  end

  # Show page configuration
  show do
    attributes_table do
      row "Preview Link" do |song|
        link_to "Preview", song_path(song), target: :_blank, rel: :noopener
      end
      row :image do |song|
        image_tag song.image[:thumb].url if song.image.present?
      end
      row :title
      row :alternate_title
      row :composer do |song|
        link_to song.composer.name, song.composer.url, target: :_blank, rel: :noopener if song.composer
      end
      row "Composer (legacy)" do |song|
        # Display legacy composer information if present
        text = song.composer_name.presence
        if song.composer_url.present?
          link_to(text || song.composer_url, song.composer_url, target: :_blank, rel: :noopener)
        else
          text
        end
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
            div id: "song-chords", data: song.chords.to_json
          end
        end
      end

      table_for song.chord_forms.order(:position), id: "chord-forms" do
        column :chord
        column :fingering do |chord_form|
          div class: "chord-form", 'data-fingering': chord_form.fingering
        end
      end

      row :categories do |song|
        song.categories.map(&:name).to_sentence
      end
      row :languages do |song|
        song.languages.map(&:name).to_sentence
      end
    end

    panel "Recordings" do
      table_for song.recordings, class: :recordings do
        column :title
        column :url do |recording|
          link_to recording.url, recording.url, target: :_blank, rel: :noopener
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
