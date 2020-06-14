class Project < ApplicationRecord
  MODEL_INITIAL = 'PJ'.freeze

  include EnhancedCounterCache
  belongs_to :organization
  has_many :notifications, dependent: :destroy
  has_many :hits, through: :notifications

  validates_uniqueness_of :host, case_sensitive: true
  validates_uniqueness_of :name, scope: :organization_id, case_sensitive: true

  counter_cache_column :scheduled_notifications_count, ->(project) { project.notifications.scheduled.count }
  counter_cache_column :in_live_notifications_count, ->(project) { project.notifications.in_live.count }

  def next_on_air
    @next_on_air ||= notifications.scheduled.order(live_start_at: :asc).first
  end
end
