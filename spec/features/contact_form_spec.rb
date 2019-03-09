RSpec.describe 'As a guest' do
  let(:name) { FFaker::Name.name }
  let(:email) { FFaker::Internet.email }
  let(:subject_text) { FFaker::Lorem.sentence }
  let(:message) { FFaker::Lorem.sentence }

  before do
    visit new_contact_form_path
  end

  scenario 'I can use the contact form' do
    fill_in 'Name', with: name
    fill_in 'Email', with: email
    fill_in 'Subject', with: subject_text
    fill_in 'Message', with: message
    click_on 'Submit'
    expect(page).to have_content I18n.t('contact_forms.success')
    expect(last_email.to).to include ENV['contact_form_email']
    expect(last_email.from).to include email
  end

  scenario 'with a failed negative captcha' do
    fill_in 'Message', with: message
    find(:xpath, "//input[@id='contact_form_nickname']", visible: false).set 'foo'
    click_on 'Submit'
    expect(page).to have_content I18n.t('contact_forms.success')
    expect(last_email).to be_nil
  end
end