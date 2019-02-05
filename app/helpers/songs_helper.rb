module SongsHelper
  def songs_sort_value
    if @q && @q.sorts.present?
      [
        @q.sorts.first.name,
        @q.sorts.first.dir
      ].join(' ')
    end
  end
end
