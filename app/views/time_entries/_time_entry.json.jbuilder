json.extract! time_entry, :id, :start_time, :end_time, :description, :task, :notes, :created_at, :updated_at
json.url time_entry_url(time_entry, format: :json)
