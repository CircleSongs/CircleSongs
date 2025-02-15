Rails.application.config.after_initialize do
  module ActiveAdminViteJS
    def stylesheet_pack_tag(style, **options)
      style = "active_admin.scss" if style == "active_admin.css"
      vite_stylesheet_tag(style, **options)
    end

    def javascript_pack_tag(script, **options)
      vite_javascript_tag(script, **options)
    end
  end

  # Include in Base pages
  ActiveAdmin::Views::Pages::Base.include ActiveAdminViteJS

  # Include in LoggedOut pages if the constant exists
  if defined?(ActiveAdmin::Views::Pages::LoggedOut)
    ActiveAdmin::Views::Pages::LoggedOut.include ActiveAdminViteJS
  end
end
