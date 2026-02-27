RSpec.describe "As an admin user" do
  let(:user) { users(:admin) }
  let(:chord) { "C#m7" }
  let(:valid_fingering) do
    <<-JSON
    {
      "chord": [
        [1, 2],
        [2, 1],
        [3, 2],
        [4, 0],
        [5, "x"],
        [6, "x"]
      ],
      "position": 5,
      "barres": [{ "fromString": 5, "toString": 1, "fret": 1 }]
    }
    JSON
  end

  before do
    login_as user
    visit admin_chord_forms_path
  end

  scenario "chord links to show page" do
    chord_form = chord_forms(:Am7)

    within "#chord_form_#{chord_form.id}" do
      click_link chord_form.chord
    end

    expect(page).to have_current_path(admin_chord_form_path(chord_form))
  end

  scenario "songs count links to songs filtered by chord form" do
    chord_form = chord_forms(:Am7)

    within "#chord_form_#{chord_form.id}" do
      click_link chord_form.songs.size.to_s
    end

    expect(page).to have_current_path(admin_songs_path(q: { chord_forms_id_in: [chord_form.id] }))
  end

  scenario "my fixture works", :js do
    expect(page).to have_selector "div.chord-form svg"
  end

  scenario "I can manage ChordForms", :js do
    click_on "New Chord Form"
    fill_in "Chord", with: chord
    fill_in "Fingering", with: valid_fingering
    click_on "Create Chord form"
    expect(page).to have_content "Chord form was successfully created."
    expect(page).to have_selector "div.chord-form svg"
    visit admin_chord_forms_path
    expect(page).to have_selector "div.chord-form svg"
  end
end
