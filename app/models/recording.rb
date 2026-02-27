class Recording < ApplicationRecord
  self.ignored_columns += %i[url embedded_player reported]

  SOURCE_PATTERNS = {
    soundcloud: %r{\Ahttps?://(w\.)?soundcloud\.com/(player/\?|[\w-]+/[\w-]+)(\?.*)?}i,
    youtube: %r{\Ahttps?://(?:www\.)?youtube\.com/watch\?v=[\w-]+}i,
    spotify: %r{\Ahttps?://open\.spotify\.com/embed/track/([\w-]+)}i,
    bandcamp: %r{\Ahttps?://bandcamp\.com/EmbeddedPlayer/(album|track)=\d+}i
  }.freeze

  belongs_to :song, touch: true

  validates :external_media_url, presence: true, on: :create
  validate :external_media_url_format

  default_scope { order(:position) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      description
      external_media_url
      id
      position
      song_id
      title
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[song]
  end

  def source
    case external_media_url
    when /soundcloud/ then :soundcloud
    when /youtube/ then :youtube
    when /spotify/ then :spotify
    when /bandcamp/ then :bandcamp
    end
  end

  def formatted_external_media_url
    return external_media_url if external_media_url.blank?

    case source
    when :youtube
      match = external_media_url.match(%r{youtube\.com/watch\?v=([\w-]+)})
      return external_media_url unless match

      video_id = match[1]
      "https://www.youtube.com/embed/#{video_id}"
    when :soundcloud
      if external_media_url.match?(%r{w\.soundcloud\.com/player/})
        uri = URI.parse(external_media_url)
        params = URI.decode_www_form(uri.query)
        api_url = params.assoc("url")&.last
        return external_media_url if api_url.blank?
      else
        api_url = external_media_url
      end

      "https://w.soundcloud.com/player/?url=#{CGI.escape(api_url)}&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"
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
end
