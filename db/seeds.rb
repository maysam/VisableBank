# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

checking = Account.create! balance_cents: 60_00, account_number: '111-222-333', account_type: 'Checking', status: 'Active'
saving = Account.create! balance_cents: 40_00, account_number: '111-415-333', account_type: 'Saving', status: 'Active'

checking.transactions.create sent_cents: 40_00, balance_cents: 60_00
saving.transactions.create received_cents: 40_00, balance_cents: 40_00

