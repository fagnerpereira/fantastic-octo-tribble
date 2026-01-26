class Job < ApplicationRecord
  belongs_to :client, class_name: "User"
  belongs_to :worker, class_name: "User", optional: true
  has_one :chat

  enum :status, { open: "open", in_progress: "in_progress", completed: "completed" }

  validates :title, presence: { message: "é obrigatório" },
    length: { minimum: 3, maximum: 100,
             too_short: "deve ter pelo menos %{count} caracteres",
             too_long: "deve ter no máximo %{count} caracteres" }

  validates :description, presence: { message: "é obrigatória" },
    length: { minimum: 10, maximum: 1000,
             too_short: "deve ter pelo menos %{count} caracteres",
             too_long: "deve ter no máximo %{count} caracteres" }

  validates :price, presence: { message: "é obrigatório" },
    numericality: { greater_than: 0,
                   message: "deve ser maior que zero" }

  validates :status, presence: true

  # Custom validation
  validate :price_must_be_reasonable

  private

  def price_must_be_reasonable
    if price.present? && price > 100000
      errors.add(:price, "parece muito alto. Verifique o valor (máximo R$ 100.000)")
    end
  end
end
