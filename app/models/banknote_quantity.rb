class BanknoteQuantity < ApplicationRecord
  AVAILABLE_NOMINAL = %w[1 2 5 10 25 50].freeze

  belongs_to :atm_device

  validates :nominal, inclusion: { in: AVAILABLE_NOMINAL }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :nominal, uniqueness: { scope: :atm_device }

  scope :in_stock, -> { where.not(amount: 0) }
end
