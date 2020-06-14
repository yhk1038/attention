class Hit < ApplicationRecord
  belongs_to :notification, counter_cache: true

  def self.for_a_week(standard_date = Date.today, format: nil)
    range = standard_date.beginning_of_week..standard_date.end_of_week
    group_by_period(:day, :created_at, day_start: 0, range: range, format: format).count
  end

  def self.for_a_month(standard_date = Date.today)
    range = standard_date.beginning_of_month..standard_date.end_of_month
    group_by_period(:week, :created_at, week_start: :monday, range: range).count
  end
end
