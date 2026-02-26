class RestrictedCategorySessionsController < ApplicationController
  def new; end

  def create
    if authorized?
      session[:restricted_categories] = true
      redirect_to sacred_info_path
    else
      session[:restricted_categories] = false
      flash[:error] = "Invalid credentials."
      render :new
    end
  end

  private
    def auth_params
      params.require(:restricted_category_session).permit :password
    end

    def authorized?
      auth_params[:password] == Password.restricted_songs
    end
end
