RSpec.describe "Admin Languages", type: :system do
  let(:user) { users(:admin) }
  let(:language) { languages(:english) }

  before do
    login_as user
  end

  scenario "I can view the languages index page" do
    visit admin_languages_path

    expect(page).to have_content language.name
  end

  scenario "I can see drag handles on the index page" do
    visit admin_languages_path

    expect(page).to have_css "td.handle", minimum: 1
    expect(page).to have_content "☰"
  end

  scenario "I can reorder languages via drag and drop", :js do
    english = languages(:english)
    spanish = languages(:spanish)
    katchwa = languages(:katchwa)

    visit admin_languages_path

    ids_from_rows = page.all("table.data-table tbody tr").map { |r| r[:id].sub(/^[^_]+_/, "") }
    expect(ids_from_rows).to eq [english, spanish, katchwa].map(&:id)

    new_order = [katchwa, english, spanish].map(&:id)
    ids_param = new_order.map { |id| "ids[]=#{id}" }.join("&")
    page.execute_script <<~JS
      var csrfMeta = document.querySelector('meta[name="csrf-token"]');
      var headers = { "Content-Type": "application/x-www-form-urlencoded" };
      if (csrfMeta) { headers["X-CSRF-Token"] = csrfMeta.content; }
      fetch(window.location.pathname + "/sort", {
        method: "POST",
        headers: headers,
        body: "#{ids_param}"
      });
    JS
    sleep 0.5

    visit admin_languages_path
    reordered_ids = page.all("table.data-table tbody tr").map { |r| r[:id].sub(/^[^_]+_/, "") }
    expect(reordered_ids).to eq new_order
  end

  scenario "songs count links to songs filtered by language" do
    visit admin_languages_path

    within "#language_#{language.id}" do
      click_link language.songs.size.to_s
    end

    expect(page).to have_current_path(admin_songs_path(q: { languages_id_in: [language.id] }))
  end
end
