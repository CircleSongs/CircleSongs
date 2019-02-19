class SongsController < ApplicationController
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
    params.has_key?(:q) ? params.require(:q).permit(
      :title_cont,
      :title_start,
      :s,
      :chords_present,
      :languages_id_in,
      :categories_id_in
    ) : {}
  end
end
