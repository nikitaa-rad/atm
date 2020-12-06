class CreateAtmDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :atm_devices do |t|
      t.string :currency, default: 'usd', null: false
      t.timestamps
    end
  end
end
