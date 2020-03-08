# frozen_string_literal: true

class AccountController < ApplicationController
  def overview
    account = Account.find_by_account_number! params[:account_number]
    render json: BankingService.account_overview(account)
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, body: 'Account number is invalid'
  end
end
