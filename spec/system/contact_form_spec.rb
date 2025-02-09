RSpec.describe 'As a guest', type: :system do
  let(:name) { FFaker::Name.name }
  let(:email) { FFaker::Internet.email }
  let(:subject_text) { FFaker::Lorem.sentence }
  let(:message) { FFaker::Lorem.sentence }

  before do
    visit new_contact_form_path
  end

  scenario 'I can use the contact form' do
    fill_in 'Name (optional)...', with: name
    fill_in 'Email (optional)...', with: email
    fill_in 'Subject...', with: subject_text
    fill_in 'Message...', with: message
    click_on 'Submit'
    expect(page).to have_content I18n.t('contact_forms.success')
    expect(last_email.to).to include Rails.application.credentials.contact_email
    expect(last_email.from).to include email
    expect(page).to have_current_path songs_path
  end

  scenario 'with incomplete ContactForm data' do
    click_on 'Submit'
    expect(page).to have_content "Message can't be blank"
    fill_in 'Message...', with: message
    click_on 'Submit'
    expect(page).to have_content I18n.t('contact_forms.success')
    expect(last_email.from).to include ContactForm::DEFAULT_FROM_EMAIL
    expect(last_email.subject).to eq ContactForm::DEFAULT_SUBJECT
  end

  scenario 'with a failed negative captcha' do
    fill_in 'Message...', with: message
    find(:xpath, "//input[@id='contact_form_nickname']", visible: false).set 'foo'
    click_on 'Submit'
    expect(page).to have_content I18n.t('contact_forms.success')
    expect(last_email).to be_nil
  end
end
