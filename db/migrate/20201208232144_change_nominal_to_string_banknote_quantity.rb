class ChangeNominalToStringBanknoteQuantity < ActiveRecord::Migration[6.0]
  def change
    change_column :banknote_quantities, :nominal, :string
  end
end
