# frozen_string_literal: true

require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  test 'should get overview' do
    account = accounts(:active_saving)
    get account_overview_url(account.account_number)

    assert_response :success

    response = JSON.parse @response.body

    assert_equal response['balance_cents'], account.balance_cents
    assert_equal response['transactions'][0], transactions(:one).as_json
    assert_equal response['transactions'][1], transactions(:two).as_json
  end

  test 'only returns last ten transactions' do
    from_account = accounts(:active_saving)
    target_account = accounts(:active_checking)
    amount = 1_50
    user_description = 'ransom money :D'

    10.times do
      post transaction_transfer_url, params: {
        from: from_account.account_number,
        to: target_account.account_number,
        amount: amount,
        user_description: user_description
      }
      post transaction_transfer_url, params: {
        from: target_account.account_number,
        to: from_account.account_number,
        amount: amount,
        user_description: user_description
      }
    end

    get account_overview_url(from_account.account_number)

    response = JSON.parse @response.body

    assert_equal response['transactions'].count, 10
    assert_equal response['transactions'][0]['balance_cents'], from_account.balance_cents
  end

  test 'should inform caller when account number is invalid' do
    get account_overview_url('whatever')

    assert_response :not_found
    assert_equal @response.body, 'Account number is invalid'
  end
end
