# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    # Featured songs for the carousel - try featured first, fallback to random
    @featured_songs = if Song.respond_to?(:featured)
      Song.featured.limit(3)
    else
      Song.order("RANDOM()").limit(3) # PostgreSQL
      # Song.order("RAND()").limit(3) # MySQL - use this if you're on MySQL
    end
    
    # Categories with song counts
    @categories = if session[:restricted_categories]
      Category.all
    else
      Category.unrestricted
    end
    
    # Themes for the cloud
    if respond_to?(:feature_enabled?) && feature_enabled?(:tagging)
      @themes = ActsAsTaggableOn::Tag.for_context(:themes)
                  .joins(:taggings)
                  .group(:id, :name)
                  .select('tags.*, COUNT(taggings.id) as taggings_count')
                  .order('taggings_count DESC')
    end
  end
end