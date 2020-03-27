module SongsHelper
  def songs_sort_value
    return unless @q && @q.sorts.present?
    [
      @q.sorts.first.name,
      @q.sorts.first.dir
    ].join(' ')
  end
end
