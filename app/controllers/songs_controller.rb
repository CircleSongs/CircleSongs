class SongsController < ApplicationController
  IN_PREDICATES = %i[themes_name_in languages_id_in categories_id_in].freeze
  UUID_PREDICATES = %i[languages_id_in categories_id_in].freeze
  UUID_FORMAT = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
  SEARCH_PREDICATES = [
    :title_cont, :composer_name_cont, :title_or_lyrics_or_composer_name_cont,
    :title_start, :s, :chords_present,
    *IN_PREDICATES, IN_PREDICATES.index_with { [] }
  ].freeze

  before_action :set_categories, only: :index
  before_action :set_themes, only: :index
  before_action :set_playlists, only: :index

  def index
    @q = Song.ransack(search_params)
    @q.sorts = "title asc" if @q.sorts.empty?
    scope = @q.result.includes(:composer, :languages)
    scope = scope.includes(:recordings) if user_signed_in?
    @songs = scope.page(params[:page]).per(per_page)
  end

  def show
    @song = Song.friendly.find params.expect(:id)
    redirect_to @song, status: :moved_permanently if params[:id] != @song.to_param
  end

  private
    def raw_search_params
      params.permit(q: SEARCH_PREDICATES).fetch(:q, {}).tap do |q|
        UUID_PREDICATES.each do |key|
          q[key] = Array(q[key]).grep(UUID_FORMAT) if q.key?(key)
        end
      end
    end

    def search_params
      if session[:restricted_categories] == true
        raw_search_params
      else
        raw_search_params.merge categories_id_not_in: Category.restricted.map(&:id)
      end
    end

    def per_page
      params[:per_page].presence || 50
    end

    def set_categories
      @categories =
        if session[:restricted_categories]
          Category.all
        else
          Category.unrestricted
        end
    end
end
