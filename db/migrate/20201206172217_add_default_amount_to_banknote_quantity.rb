class AddDefaultAmountToBanknoteQuantity < ActiveRecord::Migration[6.0]
  def change
    change_column_default :banknote_quantities, :amount, 0
  end
end
