class Transaction < ApplicationRecord
  belongs_to :atm_device

  validates :banknotes, :transaction_type, presence: true

  enum transaction_type: { purchasing: 'purchasing', withdrawal: 'withdrawal' }
end
