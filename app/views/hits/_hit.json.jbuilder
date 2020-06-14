json.extract! hit, :id, :ip_address, :notification_id, :created_at, :updated_at
json.url hit_url(hit, format: :json)
