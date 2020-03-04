# frozen_string_literal: true

class AccountController < ApplicationController
  def overview
    account = Account.find_by_account_number! params[:account_number]
    render json: {
      balance_cents: account.balance_cents,
      transactions: account.transactions.order(id: :desc).first(10)
    }
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, body: 'Account number is invalid'
  end
end
