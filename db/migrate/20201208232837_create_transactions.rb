class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :atm_device, index: true, foreign_key: true, null: false
      t.json :banknotes, null: false

      t.timestamps
    end
  end
end
