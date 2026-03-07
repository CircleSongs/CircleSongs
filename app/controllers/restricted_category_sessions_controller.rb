class RestrictedCategorySessionsController < ApplicationController
  def new; end

  def create
    if authorized?
      session[:restricted_categories] = true
      redirect_to sacred_info_path
    else
      session[:restricted_categories] = false
      flash[:error] = t(".invalid_credentials")
      render :new
    end
  end

  private
    def auth_params
      params.expect restricted_category_session: [:password]
    end

    def authorized?
      auth_params[:password] == Password.restricted_songs
    end
end
