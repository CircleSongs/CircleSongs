ActiveAdmin.register Song do
  # Filters for index page
  filter :image_data_not_null, label: "Has Image", as: :boolean
  filter :title
  filter :alternate_title
  filter :composer_name_cont
  filter :languages, multiple: true
  filter :categories, multiple: true
  filter :chords_present, as: :boolean
  filter :chord_forms_id_not_null, label: "With Chord forms", as: :boolean
  filter :composer_id_not_null, label: "Has Composer", as: :boolean
  filter :lyrics
  filter :translation
  filter :description
  filter :slug
  filter :recordings_reported, as: :boolean, label: "Broken Link Reported"
  filter :recordings_url_present, label: "Has Recording URL", as: :boolean

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
                  external_media_url
                  title
                  url
                  id
                  position
                  reported
                  _destroy
                ],
                song_chord_forms_attributes: %i[id chord_form_id _destroy position],
                category_ids: [],
                language_ids: [],
                theme_list: []

  # Index page configuration

  index do
    column :image do |song|
      image_tag song.image_url(:thumb) if song.image_url(:thumb)
    end
    column :title, sortable: true
    column :composer, sortable: 'composers.name' do |song|
      if song.composer.present?
        if song.composer.url.present?
          link_to song.composer.name, song.composer.url, target: :_blank, rel: :noopener if song.composer
        else
          song.composer.name
        end
      end
    end
    column "Has Chords", sortable: :chords do |song|
      song.chords.present? ? "Yes" : "No"
    end
    column "Has Chord Forms", :chord_forms, sortable: :chord_forms_count do |song|
      song.chord_forms.exists? ? "Yes" : "No"
    end
    column :created_at do |resource|
      l resource.created_at, format: :short
    end
    column :updated_at do |resource|
      l resource.updated_at, format: :short
    end
    actions
  end

  # Form configuration
  form do |f|
    f.inputs "Details" do
      f.input :image, as: :file,
                      hint: (image_tag f.object.image_url(:thumb) if f.object.image_url(:thumb))
      f.input :remove_image, as: :boolean
      f.input :title
      f.input :alternate_title
      f.inputs "Composer" do
        f.input :composer_id, as: :select,
                              collection: Composer.order(:name).map { |c| [[c.name, c.url].reject(&:blank?).join(" | "), c.id] },
                              input_html: { class: 'tom-select' },
                              prompt: "Existing composer"
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

      f.input :theme_list, as: :select, label: "Themes",
                           collection: (ActsAsTaggableOn::Tag.for_context(:themes).pluck(:name) + f.object.theme_list.to_a).uniq.sort,
                           input_html: { multiple: true, class: 'tom-select-tags' },
                           hint: "Select existing themes or type to add new ones"

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
        a.input :external_media_url, hint: "Supported: SoundCloud, YouTube, Spotify, Bandcamp. <a href=\"#\" onclick=\"document.getElementById('recording-instructions-modal').style.display='block'; return false;\" style=\"font-size:0.9em;\">Instructions</a>".html_safe
        a.input :url unless a.object.new_record?
        a.input :embedded_player, input_html: { rows: 5 } unless a.object.new_record?
        a.input :description, input_html: { rows: 5 }
        a.input :reported
      end
    end

    # Instructions Modal
    div id: "recording-instructions-modal", style: "display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.4);" do
      div style: "background-color:#fefefe; margin:5% auto; padding:20px; border:1px solid #888; width:80%; max-width:600px; border-radius:8px; position:relative;" do
        span style: "color:#aaa; float:right; font-size:28px; font-weight:bold; cursor:pointer;", onclick: "document.getElementById('recording-instructions-modal').style.display='none'" do
          raw "&times;"
        end
        h2 "External Media URL Instructions"

        h3 "YouTube"
        ul do
          li "Copy the URL directly from your browser's address bar"
          li raw "Example: <code>https://www.youtube.com/watch?v=dQw4w9WgXcQ</code>"
        end

        h3 "SoundCloud"
        ul do
          li "Copy the URL directly from your browser's address bar"
          li raw "Example: <code>https://soundcloud.com/artist-name/track-name</code>"
        end

        h3 "Spotify"
        ul do
          li "1. Go to the track page on Spotify"
          li "2. Click the 'Share' button (might be under ... menu)"
          li "3. Click 'Embed track'"
          li "4. Check the 'Show code' checkbox"
          li "5. Copy the iframe src URL"
          li raw "Example: <code>https://open.spotify.com/embed/track/4cOdK2wGLETKBW3PvgPWqT</code>"
        end

        h3 "Bandcamp"
        ul do
          li { strong "Important: " + "Bandcamp requires the embed URL, not the page URL" }
          li "1. Go to the track or album page on Bandcamp"
          li "2. Click the 'Share / Embed' button"
          li "3. In the embed code, find the iframe src URL"
          li raw "4. Copy only the URL from the src attribute (starts with <code>https://bandcamp.com/EmbeddedPlayer/</code>)"
          li raw "Example: <code>https://bandcamp.com/EmbeddedPlayer/album=1764593721/size=large/...</code>"
        end
      end
    end

    f.actions
  end

  # Show page configuration
  # Remove default actions
  config.action_items.delete_if { |item| %i[edit destroy].include?(item.name) }

  action_item :preview, only: :show do
    link_to "Preview", song_path(song)
  end

  action_item :edit, only: :show do
    link_to "Edit", edit_admin_song_path(song)
  end

  action_item :destroy, only: :show do
    link_to "Delete", admin_song_path(song), method: :delete, data: { confirm: "Are you sure?" }, style: "background-color: #d32f2f; color: white;"
  end

  show do
    attributes_table do
      row :image do |song|
        image_tag song.image_url(:thumb) if song.image_url(:thumb)
      end
      row :title
      row :alternate_title
      row :composer do |song|
        link_to song.composer.name, song.composer.url, target: :_blank, rel: :noopener if song.composer
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

      row :themes do |song|
        song.themes.map(&:name).to_sentence
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
        column :external_media_url do |recording|
          if recording.source.present?
            render "recordings/players/#{recording.source}", recording: recording
          else
            "No player available"
          end
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
