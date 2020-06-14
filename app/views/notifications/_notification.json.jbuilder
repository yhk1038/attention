json.extract! notification, :id, :title, :content, :project_id, :live_start_at, :live_stop_at, :created_at, :updated_at
json.url notification_url(notification, format: :json)
