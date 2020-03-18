require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  test "client can only have maximum 3 accounts" do
    client = clients(:one)

    client.accounts.destroy_all

    assert_difference('Account.count', 3) do
      client.accounts.create account_number: 'A1', balance_cents: 0
      client.accounts.create account_number: 'A2', balance_cents: 0
      client.accounts.create account_number: 'A3', balance_cents: 0
      client.accounts.create account_number: 'A4', balance_cents: 0
      client.accounts.create account_number: 'A5', balance_cents: 0
    end

    assert_equal 3, client.accounts.count
  end
end
