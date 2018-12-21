class SongLink < ApplicationRecord
  belongs_to :song
  has_many :comments, as: :commentable
end
