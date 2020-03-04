# frozen_string_literal: true

require 'test_helper'

class TransactionControllerTest < ActionDispatch::IntegrationTest
  test 'should make transfer' do
    from_account = accounts(:active_saving)
    target_account = accounts(:active_checking)
    amount = 34_50
    user_description = 'ransom money :D'

    assert_difference('Transaction.count', 2) do
      post transaction_transfer_url, params: {
        from: from_account.account_number,
        to: target_account.account_number,
        amount: amount,
        user_description: user_description
      }
    end
    assert_response :success

    lastTransaction1, lastTransaction2 = Transaction.last(2)

    assert_equal lastTransaction1.sent_cents, amount
    assert_equal lastTransaction2.received_cents, amount
  end
end
