class AddClientToAccount < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts, :client, foreign_key: true
  end
end
