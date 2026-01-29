# db/seeds.rb

require "fileutils"
require "open3"

SEED_TMP_DIR      = Rails.root.join("tmp", "seeds").freeze
PLACEHOLDER_PATH  = SEED_TMP_DIR.join("placeholder.png").freeze

FileUtils.mkdir_p(SEED_TMP_DIR)

def ensure_placeholder_image!
  return if File.exist?(PLACEHOLDER_PATH) && File.size(PLACEHOLDER_PATH).positive?

  cmd = ["magick", "-size", "10x10", "xc:none", PLACEHOLDER_PATH.to_s]
  stdout, stderr, status = Open3.capture3(*cmd)

  unless status.success? && File.exist?(PLACEHOLDER_PATH) && File.size(PLACEHOLDER_PATH).positive?
    raise <<~MSG
      Failed to generate placeholder image.
      Command: #{cmd.join(" ")}
      Status: #{status.exitstatus}
      STDOUT: #{stdout}
      STDERR: #{stderr}
    MSG
  end
end

def ensure_song_image!(song)
  return nil if song.respond_to?(:image_data) && song.image_data.present?

  ensure_placeholder_image!

  # Keep file handle open until AFTER save! completes (Shrine/derivatives may read it during callbacks)
  f = File.open(PLACEHOLDER_PATH, "rb")

  # Helps some uploaders/processing chains
  begin
    f.define_singleton_method(:original_filename) { "placeholder.png" }
  rescue StandardError
    # ignore
  end

  song.image = f
  f
end

def upsert_song!(title:, **attrs)
  song = Song.find_or_initialize_by(title: title)
  song.assign_attributes(attrs)

  fh = ensure_song_image!(song)
  song.save!
  song
ensure
  fh&.close
end

# ------------------------------------------------------------
# Seeds
# ------------------------------------------------------------

User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

english = Language.find_or_create_by!(name: "English")
spanish = Language.find_or_create_by!(name: "Spanish")
katchwa = Language.find_or_create_by!(name: "Katchwa")

Password.find_or_create_by!(name: "Restricted Songs") do |p|
  p.value = "foo"
end

eagles = Composer.find_or_create_by!(name: "The Eagles")

popular     = Category.find_or_create_by!(name: "Popular")     { |c| c.restricted = false }
traditional = Category.find_or_create_by!(name: "Traditional") { |c| c.restricted = false }
sacred      = Category.find_or_create_by!(name: "Sacred")      { |c| c.restricted = false }
restricted  = Category.find_or_create_by!(name: "Restricted")  { |c| c.restricted = true }

ChordForm.find_or_create_by!(chord: "Am7") do |cf|
  cf.fingering = "{\"chord\": [[1, \"x\"], [2, 1], [3, \"x\"], [4, 3], [5, 0], [6, \"x\"] ] }"
end

hotel = upsert_song!(
  title: "Hotel California",
  alternate_title: "Most Popular Song In The World",
  composer: eagles,
  lyrics: "On a dark desert highway, cool wind in my hair...",
  translation: "En un calle oscuro...",
  chords: "[Dm]On a dark desert [A]highway, [Em]cool wind in my hair...",
  description: nil
)

condor = upsert_song!(title: "El Condor Pasa")
taki   = upsert_song!(title: "Taki Taki Muyki")
locked = upsert_song!(title: "Restricted Song")

Recording.find_or_create_by!(title: "Sound Cloud", song: hotel) do |r|
  r.external_media_url = "http://soundcloud.com/hotel-california"
end

Recording.find_or_create_by!(title: "The Eagles Website", song: hotel) do |r|
  r.external_media_url = "http://theeagles.com/hotel-california"
end

hotel.languages << english unless hotel.languages.exists?(english.id)
condor.languages << spanish unless condor.languages.exists?(spanish.id)
condor.languages << katchwa unless condor.languages.exists?(katchwa.id)
taki.languages << katchwa unless taki.languages.exists?(katchwa.id)
locked.languages << english unless locked.languages.exists?(english.id)

hotel.categories << popular unless hotel.categories.exists?(popular.id)
condor.categories << traditional unless condor.categories.exists?(traditional.id)
taki.categories << sacred unless taki.categories.exists?(sacred.id)
locked.categories << restricted unless locked.categories.exists?(restricted.id)

puts "✅ Seeds loaded successfully"
