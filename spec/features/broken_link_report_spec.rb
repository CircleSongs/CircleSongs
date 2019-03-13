RSpec.feature 'As a guest' do
  let(:song) { songs(:hotel_california) }
  let(:recording) { song.recordings.first }

  scenario 'I can report a recording with a broken link', :js do
    visit song_path(song)
    within "#recording-#{recording.id}" do
      accept_confirm do
        find('.fa-unlink').click
      end
      expect(page).to have_content 'Reported'
    end
    expect(last_email.subject).to eq I18n.t('broken_link_forms.email.subject', title: song.title)

    visit song_path(song)

    within "#recording-#{recording.id}" do
      expect(page).to have_content 'Reported'
    end
  end
end
