class Song < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  include ImageUploader::Attachment.new(:image)

  has_many :recordings, -> { order :created_at }
  accepts_nested_attributes_for :recordings, reject_if: proc { |attributes|
    attributes["url"].blank? && attributes["embedded_player"].blank?
  }, allow_destroy: true
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :categories
  has_many :song_chord_forms, dependent: :destroy
  accepts_nested_attributes_for :song_chord_forms, allow_destroy: true, reject_if: :all_blank
  has_many :chord_forms, through: :song_chord_forms
  accepts_nested_attributes_for :chord_forms, allow_destroy: true, reject_if: :all_blank
  belongs_to :composer, counter_cache: true, optional: true

  def formatted_chords
    @formatted_chords ||= Chordpro.html(chords)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[alternate_title chords composer_name composer_url created_at description id
       id_value image_data lyrics slug title translation updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[categories chord_forms languages recordings song_chord_forms composer]
  end

  # Temp code until we get rid of song#composer_name and song#composer_url
  # in favor of song#composer
  ransacker :composer_search do |parent|
    Arel::Nodes::OrNode.new(
      parent.table[:composer_name],
      parent.table.join(Composer.arel_table)
        .on(parent.table[:composer_id].eq(Composer.arel_table[:id]))
        .project(Composer.arel_table[:name])
    )
  end
end
