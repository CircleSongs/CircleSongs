module ActiveAdminViteJS
  def stylesheet_pack_tag(style, **options)
    style = "active_admin.scss" if style == "active_admin.css"
    vite_stylesheet_tag(style, **options)
  end

  def javascript_pack_tag(script, **options)
    vite_javascript_tag(script, **options)
  end
end

ActiveAdmin::Views::Pages::Base.include ActiveAdminViteJS
