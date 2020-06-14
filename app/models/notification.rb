class Notification < ApplicationRecord
  MODEL_INITIAL = 'NT'.freeze

  belongs_to :project, counter_cache: true
  has_many :hits, dependent: :destroy

  scope :published, -> { where(published: true) }
  scope :scheduled, -> { published.where('live_start_at > ?', Time.zone.now) }
  scope :in_live, -> { published.where('live_start_at <= :now AND live_stop_at >= :now', now: Time.zone.now) }

  after_save do |notification|
    if notification.published?
      notification.project.tap do |project|
        project.update_scheduled_notifications_count if notification.will_live?
        project.update_in_live_notifications_count if notification.in_live?
      end
    end
  end

  def draft?
    !published?
  end

  def will_live?
    return false unless published?

    Time.zone.now < live_start_at
  end

  def did_live?
    return false unless published?

    live_stop_at < Time.zone.now
  end

  def in_live?
    return false unless published?

    !will_live? && !did_live?
  end

  def live_status
    return :draft unless published?

    %i[will_live in_live did_live][live_status_index]
  end

  def live_status_index
    return 0 if will_live?
    return 1 if in_live?
    return 2 if did_live?

    3 # draft
  end
end
