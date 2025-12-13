class Job < ApplicationRecord
  belongs_to :client, class_name: "User"
  belongs_to :worker, class_name: "User", optional: true
  has_one :chat

  enum status: { open: "open", in_progress: "in_progress", completed: "completed" }
end
