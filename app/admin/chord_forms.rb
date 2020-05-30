ActiveAdmin.register ChordForm do
  permit_params :chord, :fingering

  index do
    column :chord
    column :fingering do |chord_form|
      div class: 'chord-form', 'data-fingering': chord_form.fingering
    end

    actions
  end

  show do
    h3 chord_form.chord
    div class: 'chord-form', 'data-fingering': chord_form.fingering
  end
end
