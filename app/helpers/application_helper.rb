module ApplicationHelper
  #removed padding for day,month, and hour
  #added non-breaking space before PM
  def date_format(utc_date)
    utc_date.strftime("%-m/%-d/%y %-I:%M\u00A0%p")
  end
end
