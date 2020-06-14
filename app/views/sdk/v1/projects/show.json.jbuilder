json.extract! @project, :id, :name, :host, :notifications_count, :scheduled_notifications_count, :in_live_notifications_count, :created_at, :updated_at
json.hits_count @project.hits.count
# json.url project_url(@project, format: :json)
json.available_notifications @project.notifications.map { |noti| noti.humanized_id.gsub('#','') }
json.organization @project.organization
json.notifications @project.notifications
