class Composer < ApplicationRecord
  validates :name, uniqueness: true, if: -> { name.present? }
  validates :url, format: {
    with: %r{\Ahttps?://\S+\.\S+\z},
    message: "must be a valid URL"
  }, if: :url?
  validate :name_or_url_present

  normalizes :name, with: ->(name) { name.strip }

  has_many :songs, dependent: :nullify

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name songs_count url]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[songs]
  end

  private
    def name_or_url_present
      return unless name.blank? && url.blank?

      errors.add(:base, "Name or URL must be present")
    end
end
