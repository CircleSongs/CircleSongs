class Song < ApplicationRecord
  self.ignored_columns = %i[composer_name composer_url]

  extend FriendlyId
  friendly_id :title, use: :slugged

  include ImageUploader::Attachment.new(:image)

  acts_as_taggable_on :themes

  validates :title, presence: true, uniqueness: true

  has_many :recordings, -> { order :created_at }, inverse_of: :song, dependent: :destroy
  accepts_nested_attributes_for :recordings, reject_if: proc { |attributes|
    attributes["url"].blank? && attributes["embedded_player"].blank? && attributes["external_media_url"].blank?
  }, allow_destroy: true
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :categories
  has_many :song_chord_forms, dependent: :destroy
  accepts_nested_attributes_for :song_chord_forms, allow_destroy: true, reject_if: :all_blank
  has_many :chord_forms, through: :song_chord_forms
  accepts_nested_attributes_for :chord_forms, allow_destroy: true, reject_if: :all_blank
  belongs_to :composer, counter_cache: true, optional: true

  scope :featured, -> { where(featured: true) }

  def formatted_chords
    @formatted_chords ||= Chordpro.html(chords)
  end

  def image_url(derivative = :large)
    image_derivatives&.dig(derivative)&.url || image&.url
  end

  ransacker :composer_name do |parent|
    subquery = Composer.select(:name).where(Composer.arel_table[:id].eq(parent.table[:composer_id])).limit(1)
    Arel::Nodes::SqlLiteral.new("(#{subquery.to_sql})")
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[image_data alternate_title chords created_at description id
       id_value image_data lyrics slug title translation updated_at featured composer_name]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[categories chord_forms languages recordings song_chord_forms composer tags themes]
  end
end
