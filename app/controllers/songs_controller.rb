class SongsController < ApplicationController
  before_action :set_categories, only: :index

  def index
    @q = SongCollection.new(params: search_params).q
    @q.sorts = "title asc" if @q.sorts.empty?
    @songs = @q.result(distinct: true).page(params[:page])
  end

  def show
    @song = Song.friendly.find params[:id]
  end

  private

  def raw_search_params
    return {} unless params[:q]

    params.require(:q).permit(
      :title_cont,
      :composer_name_cont,
      :title_start,
      :s,
      :chords_present,
      :languages_id_in,
      :categories_id_in
    )
  end

  def search_params
    if session[:restricted_categories] == true
      raw_search_params
    else
      raw_search_params.merge categories_id_not_in: Category.restricted.map(&:id)
    end
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
