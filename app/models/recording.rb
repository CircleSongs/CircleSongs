class Recording < ApplicationRecord
  SOURCE_PATTERNS = {
    soundcloud: %r{\Ahttps?://soundcloud\.com/[\w-]+/[\w-]+(\?.*)?}i,
    youtube: %r{\Ahttps?://(?:www\.)?youtube\.com/watch\?v=[\w-]+}i,
    spotify: %r{\Ahttps?://open\.spotify\.com/track/([\w-]+)}i,
    bandcamp: %r{\Ahttps?://bandcamp\.com/EmbeddedPlayer/(album|track)=\d+}i
  }

  belongs_to :song

  validates :external_media_url, presence: true, on: :create
  validates :url, presence: { unless: proc { |recording|
    recording.embedded_player.present? || recording.external_media_url.present?
  } }, on: :update
  validates :embedded_player, presence: { unless: proc { |recording|
    recording.url.present? || recording.external_media_url.present?
  } }, on: :update
  validate :external_media_url_format
  validate :external_media_url_accessible, if: -> { validate_url_accessibility? }

  default_scope { order(:position) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description embedded_player external_media_url id position reported song_id
       title updated_at url]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[song]
  end

  attr_accessor :validate_url_accessibility, :url_checker_class

  def validate_url_accessibility?
    validate_url_accessibility == true
  end

  def url_checker_class
    @url_checker_class ||= Recordings::UrlChecker
  end

  def source
    case external_media_url
    when /soundcloud/ then :soundcloud
    when /youtube/ then :youtube
    when /spotify/ then :spotify
    when /bandcamp/ then :bandcamp
    else nil
    end
  end

  def formatted_external_media_url
    return external_media_url if external_media_url.blank?

    case source
    when :youtube
      match = external_media_url.match(/youtube\.com\/watch\?v=([\w-]+)/)
      return external_media_url unless match

      video_id = match[1]
      "https://www.youtube.com/embed/#{video_id}"
    when :soundcloud
      "https://w.soundcloud.com/player/?url=#{CGI.escape(external_media_url)}&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"
    when :bandcamp
      match = external_media_url.match(%r{bandcamp\.com/EmbeddedPlayer/(album|track)=(\d+)(?:.*?/track=(\d+))?})
      return external_media_url unless match

      type = match[1]
      id = match[2]
      track_id = match[3]
      embed_url = "https://bandcamp.com/EmbeddedPlayer/#{type}=#{id}/size=small/bgcol=ffffff/linkcol=0687f5/transparent=true/"
      embed_url += "track=#{track_id}/" if track_id
      embed_url
    else
      external_media_url
    end
  end

  private

  def external_media_url_format
    return if external_media_url.blank?

    return if source && external_media_url.match?(SOURCE_PATTERNS[source])

    errors.add(:external_media_url, "must be a valid SoundCloud, YouTube, Spotify, or Bandcamp URL")
  end

  def external_media_url_accessible
    return if external_media_url.blank?

    unless url_checker_class.new(external_media_url).call
      errors.add(:external_media_url, "is not accessible or returns an error")
    end
  end
end
