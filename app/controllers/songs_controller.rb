class SongsController < ApplicationController
  before_action :set_categories, only: :index

  def index
    @q = SongCollection.new(params: search_params).q
    @q.sorts = 'title asc' if @q.sorts.empty?
    @songs = @q.result(distinct: true).page(params[:page] || 1)
  end

  def show
    @song = Song.find params[:id]
  end

  private

  def search_params
    p = if params.has_key?(:q)
      params.require(:q).permit(
        :title_cont,
        :composer_cont,
        :title_start,
        :s,
        :chords_present,
        :languages_id_in,
        :categories_id_in
      )
    else
      {}
    end
    unless session[:restricted_categories] == true
      p[:categories_id_not_in] = Category.restricted.map(&:id)
    end
    p
  end

  def set_categories
    @categories ||= if session[:restricted_categories]
      Category.all
    else
      Category.unrestricted
    end
  end
end
