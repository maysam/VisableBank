class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :client_number
      t.string :name

      t.timestamps
    end
  end
end
