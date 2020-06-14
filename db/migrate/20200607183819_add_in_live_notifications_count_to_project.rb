class AddInLiveNotificationsCountToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :in_live_notifications_count, :integer, default: 0
  end
end
