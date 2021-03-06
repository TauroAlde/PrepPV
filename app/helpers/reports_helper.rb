module ReportsHelper
  def percent_difference_color(segment)
    difference = segment.percent_difference
    return "" if difference.is_a?(String)
    difference > 10 ? "text-warning" : ""
  end

  def report_text_class(text)
    return "text-secondary" if text == "S/E"
    "font-weight-bold"
  end
end
