module ApplicationHelper
  def active_sidebar_class(link_path)
    if current_page?(link_path)
      'active'
    else
      ''
    end
  end

  def in_datetimepicker_format(value)
    value ? value.strftime('%d/%m/%Y %H-%M') : ''
  end

  def in_date_format(value)
    value ? value.strftime('%d/%m/%Y') : ''
  end

  def in_currency_format(value)
    value ? number_to_currency(value, precision: 0, unit: 'VND', delimiter: ',', format: '%u %n') : ''
  end

  # Check the resource first before calling link_to, if resource is nil, return
  # empty string instead
  def guard_link(resource, fallback = '')
    if resource
      yield
    else
      fallback
    end
  end

  def info_button(title, path)
    link_to title, path, class: 'btn btn-info'
  end

  def delete_button(path)
    link_to 'Delete', path, method: :delete, class: 'btn btn-danger', data: { confirm: 'Are you sure?' }
  end

  def edit_button(path)
    link_to 'Edit', path, class: 'btn btn-default'
  end

  def cancel_form_button(back_to_path)
    link_to 'Cancel', back_to_path, class: 'btn btn-default'
  end
end
