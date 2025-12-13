class Chat < ApplicationRecord
  belongs_to :job
  has_many :messages
  has_many :users, through: :messages
end
