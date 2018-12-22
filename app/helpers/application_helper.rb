module ApplicationHelper
  def fa_icon(icon, opts = {})
    content_tag :i, nil, class: ([:far, "fa-#{icon}"] << opts[:class])
  end
end
