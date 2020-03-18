class AddTotalCreditToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :total_credit, :numeric, default: 0
  end
end
