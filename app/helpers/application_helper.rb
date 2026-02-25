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

def active_link_class(paths)
  Array(paths).any? { |p| current_page?(p) } ? 'nav__link--current' : ''
end

  def theme_font_size(taggings_count, max_count)
    weight = max_count > 0 ? taggings_count.to_f / max_count : 0
    (80 + weight * 70).round
  end

  def excerpt_text(html, length: 150, omission: "...")
    truncate(strip_tags(html.to_s), length: length, separator: "\n", omission: omission)
  end

  def feature_enabled?(feature)
    current_user.present? && Flipper.enabled?(feature, current_user)
  end
end
