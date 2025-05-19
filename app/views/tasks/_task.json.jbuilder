json.extract! task, :id, :title, :description, :project_id, :completed, :notes, :due_date, :created_at, :updated_at
json.url task_url(task, format: :json)
