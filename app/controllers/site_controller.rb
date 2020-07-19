class SiteController < ApplicationController
  def quechua
    @vocabularies = Vocabulary.all
  end

  def icaros; end

  def integration; end

  def learning_music; end
end
