# frozen_string_literal: true

require 'test_helper'

class TransactionControllerTest < ActionDispatch::IntegrationTest
  setup do
    @from_account = accounts(:active_saving)
    @target_account = accounts(:active_checking)
  end

  test 'should make transfer' do
    amount = 34_50

    assert_difference('Transaction.count', 2) do
      post transaction_transfer_url, params: {
        from: @from_account.account_number,
        to: @target_account.account_number,
        amount: amount
      }
    end

    assert_response :success
    last_transaction1, last_transaction2 = Transaction.last(2)
    assert_equal last_transaction1.sent_cents, amount
    assert_equal last_transaction2.received_cents, amount
  end

  test 'transfer amount should be more than zero' do
    amount = -1

    post transaction_transfer_url, params: {
      from: @from_account.account_number,
      to: @target_account.account_number,
      amount: amount
    }

    assert_response :precondition_failed
    assert_equal @response.body, "Positive amount value is required"
  end

  test 'should inform caller when funds are not sufficient for the transfer' do
    amount = @from_account.balance_cents + 1

    post transaction_transfer_url, params: {
      from: @from_account.account_number,
      to: @target_account.account_number,
      amount: amount
    }

    assert_response :precondition_failed
    assert_equal @response.body, "Available funds don't cover this transfer"
  end

  test 'should inform caller if account is not found' do
    amount = @from_account.balance_cents + 1

    post transaction_transfer_url, params: {
      from: 'random',
      to: @target_account.account_number,
      amount: amount
    }

    assert_response :not_found
    assert_equal @response.body, 'Sender account number is invalid'

    post transaction_transfer_url, params: {
      from: @from_account.account_number,
      to: 'random',
      amount: amount

    }

    assert_response :not_found
    assert_equal @response.body, 'Receiver account number is invalid'
  end
end
