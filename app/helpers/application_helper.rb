module ApplicationHelper
  def time_diff_humanize(datetime)
    distance_of_time_in_words_to_now(datetime, include_seconds: true)
  end

  def time_ago_or_left(datetime)
    (Time.zone.now - datetime.in_time_zone).positive? ? 'left' : 'ago'
  end
end
