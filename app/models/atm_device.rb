class AtmDevice < ApplicationRecord
  has_many :banknote_quantities, dependent: :destroy
  has_many :transactions, dependent: :destroy
end
