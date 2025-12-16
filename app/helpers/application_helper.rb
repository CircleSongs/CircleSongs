module ApplicationHelper
  def fa_icon(icon, opts = {})
    content_tag :i, nil, class: ([:far, "fa-#{icon}"] << opts[:class]), data: opts[:data],
                         title: opts[:title]
  end

  def bootstrap_alert_class(str)
    case str
    when "alert", "error" then "danger"
    when "notice" then "info"
    else
      "success"
    end
  end

  def feature_enabled?(feature)
    current_user.present? && Flipper.enabled?(feature, current_user)
  end
end
