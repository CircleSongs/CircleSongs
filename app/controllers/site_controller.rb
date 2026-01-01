class SiteController < ApplicationController
  def about_us; end
  def resources; end
  def support_us; end
  def song_book; end

  def quechua
    @vocabularies = Vocabulary.alphabetical
  end

  def icaros; end

  def integration; end

  def learning_music; end
end
