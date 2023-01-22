json.extract! channel, :id, :name, :sensor_type, :location, :device_id, :product_id, :last_entry_timestamp, :created_at, :updated_at
json.url channel_url(channel, format: :json)
