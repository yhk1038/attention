class AddPublishedToNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :published, :boolean, default: false
  end
end
