class Comment < ApplicationRecord
  belongs_to :comentable, polymorphic: true
end
