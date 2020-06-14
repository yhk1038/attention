class AddScheduledNotificationsCountToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :scheduled_notifications_count, :integer, default: 0
  end
end
