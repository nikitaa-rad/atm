class AddTransactionTypeToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :transaction_type, :string, null: false
  end
end
