class Transaction < ApplicationRecord
  belongs_to :atm_device

  enum transaction_type: { purchasing: 'purchasing', withdrawal: 'withdrawal' }
end
