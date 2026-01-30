RSpec.feature "As a guest", type: :system do
  let(:song) { songs(:hotel_california) }
  let(:recording) { song.recordings.first }

  scenario "I can report a recording with a broken link", :js do
    skip "Functionality removed in redesign..."

    visit song_path(song)
    within "#recording-#{recording.id}" do
      accept_confirm do
        find(".fa-chain-broken").click
      end
      expect(page).to have_content "Reported"
    end
    expect(last_email.subject).to eq I18n.t("broken_link_forms.email.subject", title: song.title)

    visit song_path(song)

    within "#recording-#{recording.id}" do
      expect(page).to have_content "Reported"
    end
  end
end
