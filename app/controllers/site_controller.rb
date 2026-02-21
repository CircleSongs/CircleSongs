class SiteController < ApplicationController
  def honoring_the_artists; end
  def who_we_are; end
  def resources; end
  def song_book; end

  def quechua
    @vocabularies = Vocabulary.alphabetical
  end

  def icaros; end

  def integration; end

  def learning_music; end
end
