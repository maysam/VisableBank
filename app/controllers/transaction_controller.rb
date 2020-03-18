# frozen_string_literal: true

class TransactionController < ApplicationController
  def transfer
    source = Account.find_by_account_number params[:from]
    destination = Account.find_by_account_number params[:to]
    amount = params[:amount].to_i
    user_description = params[:user_description]

    if source.nil?
      render status: :not_found, body: 'Sender account number is invalid'
    elsif destination.nil?
      render status: :not_found, body: 'Receiver account number is invalid'
    elsif amount <= 0
      render status: :precondition_failed,
             body: 'Positive amount value is required'
    elsif source.balance_cents + source.credit < amount
      render status: :precondition_failed,
             body: "Available funds don't cover this transfer"
    else
      BankingService.transfer_funds source, destination, amount, user_description
      # head :ok
    end
  end
end
