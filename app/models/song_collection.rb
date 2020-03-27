class SongCollection
  def initialize(params: {})
    @params = params
  end

  def q
    @q ||= Song.ransack(params)
  end

  private

  attr_reader :params
end
