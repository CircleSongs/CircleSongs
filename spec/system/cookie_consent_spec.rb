require "rails_helper"

RSpec.describe "Cookie consent banner" do
  scenario "displays banner on first visit" do
    visit root_path
    expect(page).to have_css(".cookie-consent", visible: :visible)
    expect(page).to have_text("We use cookies")
  end

  scenario "hides banner after accepting" do
    visit root_path
    within(".cookie-consent") { click_button "Accept All" }
    expect(page).to have_no_css(".cookie-consent", visible: :visible)

    visit root_path
    expect(page).to have_css(".cookie-consent[hidden]", visible: :hidden)
  end

  scenario "hides banner after declining" do
    visit root_path
    within(".cookie-consent") { click_button "Necessary Only" }
    expect(page).to have_no_css(".cookie-consent", visible: :visible)

    visit root_path
    expect(page).to have_css(".cookie-consent[hidden]", visible: :hidden)
  end

  scenario "banner has accessible attributes" do
    visit root_path
    banner = find(".cookie-consent")
    expect(banner[:'aria-label']).to eq("Cookie consent")
    expect(banner[:role]).to eq("dialog")
  end
end
