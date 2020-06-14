class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :content
      t.references :project, null: false, foreign_key: true
      t.timestamp :live_start_at
      t.timestamp :live_stop_at

      t.timestamps
    end
  end
end
