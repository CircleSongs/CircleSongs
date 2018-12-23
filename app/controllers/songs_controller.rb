class SongsController < ApplicationController
  def index
    song_collection = SongCollection.new(params: search_params)
    @q = song_collection.q
    @songs = @q.result(distinct: true)
  end

  def show
    @song = Song.find params[:id]
  end

  private
  def search_params
    params.has_key?(:q) ? params.require(:q).permit(:title_cont) : {}
  end
end
