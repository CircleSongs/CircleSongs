class SiteController < ApplicationController
  def quechua
    @vocabularies = Vocabulary.alphabetical
  end

  def icaros; end

  def integration; end

  def learning_music; end
end
