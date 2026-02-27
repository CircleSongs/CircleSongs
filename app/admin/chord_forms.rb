ActiveAdmin.register ChordForm do
  menu priority: 3

  filter :chord

  permit_params :chord, :fingering

  index do
    column :chord
    column "Songs" do |chord_form|
      link_to chord_form.songs.size, admin_songs_path(q: { chord_forms_id_in: [chord_form.id] })
    end
    column :fingering do |chord_form|
      div class: "chord-form", 'data-fingering': chord_form.fingering
    end

    actions
  end

  show do
    h3 resource.chord
    div class: "chord-form", 'data-fingering': resource.fingering
  end
end
