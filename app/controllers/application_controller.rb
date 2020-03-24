class ApplicationController < ActionController::Base
  private

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
end
