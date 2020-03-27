module ApplicationHelper
  def fa_icon(icon, opts = {})
    content_tag :i, nil, class: ([:far, "fa-#{icon}"] << opts[:class])
  end

  def bootstrap_alert_class(str)
    case str
    when 'alert', 'error' then 'danger'
    when 'notice' then 'info'
    else
      'success'
    end
  end
end
