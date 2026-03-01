class Playlist < ApplicationRecord
  include Trackable

  acts_as_list
  default_scope { order(:position) }

  validates :title, presence: true
  validates :url, presence: true, format: {
    with: %r{(spotify|youtube|soundcloud|bandcamp)\.com/},
    message: "must be from Spotify, YouTube, SoundCloud, or Bandcamp"
  }

  def service
    url&.match(/(spotify|youtube|soundcloud|bandcamp)/)&.[](0)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title description position url created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
