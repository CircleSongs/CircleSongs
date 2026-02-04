class ApplicationController < ActionController::Base
  before_action :set_theme

  private
    def set_theme
      @theme = session[:theme] || 'dark'
    end

    def after_sign_out_path_for(_resource_or_scope)
      root_path
    end

    def set_themes
      @themes = ActsAsTaggableOn::Tag.for_context(:themes)
    end

    def set_playlists
      @playlists = Playlist.all
    end

    def set_categories
      @categories = session[:restricted_categories] == true ? Category.all : Category.unrestricted
    end

    def set_featured_songs
      @featured_songs = Song.featured.limit(3)
    end
end
