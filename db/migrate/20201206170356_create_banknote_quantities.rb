class CreateBanknoteQuantities < ActiveRecord::Migration[6.0]
  def change
    create_table :banknote_quantities do |t|
      t.references :atm_device, index: true, foreign_key: true, null: false
      t.integer :nominal, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
