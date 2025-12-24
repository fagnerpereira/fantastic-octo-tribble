class User < ApplicationRecord
  has_secure_password

  enum :role, { client: "client", worker: "worker" }

  has_many :posted_jobs, class_name: "Job", foreign_key: "client_id"
  has_many :accepted_jobs, class_name: "Job", foreign_key: "worker_id"
  has_many :messages
  has_many :chats, through: :messages

  validates :name, presence: { message: "é obrigatório" },
                   length: { minimum: 2, maximum: 100,
                            too_short: "deve ter pelo menos %{count} caracteres",
                            too_long: "deve ter no máximo %{count} caracteres" }

  validates :email, presence: { message: "é obrigatório" },
                    uniqueness: { message: "já está em uso" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "não é válido" }

  validates :password, length: { minimum: 6, message: "deve ter pelo menos 6 caracteres" },
                      allow_nil: true

  validates :role, presence: { message: "é obrigatório" }
end
