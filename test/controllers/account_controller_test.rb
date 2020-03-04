# frozen_string_literal: true

require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  test 'should get overview' do
    get account_overview_url

    assert_response :success

    response = JSON.parse @response.body

    assert_equal response['balance_cents'], accounts(:active_saving).balance_cents
    assert_equal response['transactions'][0], transactions(:one)
  end
end
