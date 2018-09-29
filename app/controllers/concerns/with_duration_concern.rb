module WithDurationConcern
  def parse_date_range(field_name, permitted_params)
    start_date_str = permitted_params.delete("#{field_name}_start".to_sym)
    end_date_str = permitted_params.delete("#{field_name}_end".to_sym)
    if start_date_str.present? && end_date_str.present?
      permitted_params[field_name.to_sym] = (Date.parse(start_date_str)..Date.parse(end_date_str))
    end

    permitted_params
  end
end
