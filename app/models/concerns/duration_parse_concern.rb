module DurationParseConcern
  def duration_start
    duration && in_date_format(duration.first)
  end

  def duration_end
    duration && in_date_format(duration.last)
  end
end
