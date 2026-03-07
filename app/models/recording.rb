class Recording < ApplicationRecord
  include Trackable

  self.ignored_columns += %i[url embedded_player reported description]

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
    when :youtube    then format_youtube_url
    when :soundcloud then format_soundcloud_url
    when :bandcamp   then format_bandcamp_url
    else external_media_url
    end
  end

  private
    def format_youtube_url
      match = external_media_url.match(%r{youtube\.com/watch\?v=([\w-]+)})
      return external_media_url unless match

      "https://www.youtube.com/embed/#{match[1]}"
    end

    def format_soundcloud_url
      api_url = soundcloud_api_url
      return external_media_url if api_url.blank?

      "https://w.soundcloud.com/player/?url=#{CGI.escape(api_url)}" \
        "&color=%23ff5500&auto_play=false&hide_related=false" \
        "&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"
    end

    def soundcloud_api_url
      return external_media_url unless external_media_url.match?(%r{w\.soundcloud\.com/player/})

      URI.decode_www_form(URI.parse(external_media_url).query).assoc("url")&.last
    end

    def format_bandcamp_url
      match = external_media_url.match(%r{bandcamp\.com/EmbeddedPlayer/(album|track)=(\d+)(?:.*?/track=(\d+))?})
      return external_media_url unless match

      embed_url = "https://bandcamp.com/EmbeddedPlayer/#{match[1]}=#{match[2]}" \
                  "/size=small/bgcol=ffffff/linkcol=0687f5/transparent=true/"
      embed_url += "track=#{match[3]}/" if match[3]
      embed_url
    end

    def external_media_url_format
      return if external_media_url.blank?

      return if source && external_media_url.match?(SOURCE_PATTERNS[source])

      errors.add(:external_media_url, "must be a valid SoundCloud, YouTube, Spotify, or Bandcamp URL")
    end
end
