class Category < ApplicationRecord
  has_and_belongs_to_many :songs

  def name_and_count
    str = "#{name} (#{songs.count})"
  end
end
