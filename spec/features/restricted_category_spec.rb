RSpec.feature 'As an' do
  let(:unrestricted_categories) { Category.unrestricted }
  let(:restricted_categories) { Category.restricted }
  let(:all_categories) { Category.all }
  let(:restricted_song) { songs(:restricted) }
  let(:password) { passwords(:restricted_songs).value }

  before do
    visit root_path
  end

  context 'unauthenticated guest' do
    scenario 'I cannot see restricted Categories or Songs' do
      expect(page).to have_select(
        'Category',
        options: unrestricted_categories.map(&:name_and_count).unshift('All')
      )
      expect(page).not_to have_content restricted_song.title
    end
  end

  context 'trying to login' do
    context 'with a bad password' do
      let(:password) { 'bar' }

      scenario 'I see an error' do
        visit new_restricted_category_session_path
        fill_in I18n.t('restricted_categories.password_label'), with: password
        click_on 'Submit'
        expect(page).to have_content 'Invalid credentials.'
      end
    end

    context 'with good credentials' do
      scenario 'I am redirected to Songs#index' do
        visit new_restricted_category_session_path
        fill_in I18n.t('restricted_categories.password_label'), with: password
        click_on 'Submit'
        expect(page).to have_current_path '/songs'
      end
    end
  end

  context 'an authenticated guest' do
    before do
      authorize_restricted_categories(password)
    end

    scenario 'I can see all the categories and songs' do
      expect(page).to have_select(
        'Category', options: all_categories.map(&:name_and_count).unshift('All')
      )
      expect(page).to have_content restricted_song.title
    end
  end

  scenario 'I can use a pretty url to access the sacred password' do
    visit sacred_password_path
    fill_in I18n.t('restricted_categories.password_label'), with: password
    click_on 'Submit'
    expect(page).to have_current_path '/songs'
  end
end
