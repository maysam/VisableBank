class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :user_description
      t.string :system_description
      t.integer :sent_cents
      t.integer :received_cents
      t.integer :balance_cents

      t.timestamps
    end
  end
end
