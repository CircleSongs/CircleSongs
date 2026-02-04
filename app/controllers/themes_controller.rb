class ThemesController < ApplicationController
  def update
    session[:theme] = params[:theme]
    head :ok
  end
end