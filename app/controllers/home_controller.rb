# app/controllers/home_controller.rb
class HomeController < ApplicationController
  before_action :set_themes, only: :index
  before_action :set_playlists, only: :index
  before_action :set_categories, only: :index
  before_action :set_featured_songs, only: :index

  def index; end
end
