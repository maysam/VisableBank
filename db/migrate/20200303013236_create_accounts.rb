class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :account_number
      t.integer :balance_cents
      t.string :account_type
      t.string :status

      t.timestamps
    end
  end
end
