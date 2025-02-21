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
end
