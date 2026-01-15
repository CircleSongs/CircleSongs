class Playlist < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true, format: {
    with: %r{(spotify|youtube|soundcloud|bandcamp)\.com/},
    message: "must be from Spotify, YouTube, SoundCloud, or Bandcamp"
  }
end
