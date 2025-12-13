class User < ApplicationRecord
  has_secure_password

  enum role: { client: "client", worker: "worker" }

  has_many :posted_jobs, class_name: "Job", foreign_key: "client_id"
  has_many :accepted_jobs, class_name: "Job", foreign_key: "worker_id"
  has_many :messages
  has_many :chats, through: :messages

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
end
