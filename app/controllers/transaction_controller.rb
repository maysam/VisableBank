# frozen_string_literal: true

class TransactionController < ApplicationController
  def transfer
    from_account = Account.find_by_account_number params[:from]
    to_account = Account.find_by_account_number params[:to]
    amount = params[:amount].to_i
    user_description = params[:user_description]

    if amount <= 0
      render status: :precondition_failed, body: 'Positive amount value is required'
    elsif from_account.nil?
      render status: :not_found, body: 'Sender account number is invalid'
    elsif to_account.nil?
      render status: :not_found, body: 'Receiver account number is invalid'
    else
      Transaction.transaction do
        from_account.balance_cents -= amount
        from_account.save!

        from_account.transactions.create sent_cents: amount,
                                         balance_cents: from_account.balance_cents,
                                         user_description: user_description,
                                         system_description: "sent to '#{to_account.account_number}'"
        to_account.balance_cents += amount
        to_account.save!
        to_account.transactions.create received_cents: amount,
                                       balance_cents: to_account.balance_cents,
                                       user_description: user_description,
                                       system_description: "received from '#{from_account.account_number}'"
        head :ok
      end
    end
  rescue ActiveRecord::RecordInvalid => err
    if err.message == 'Validation failed: Balance cents must be greater than or equal to 0'
      render status: :precondition_failed, body: "Available funds don't cover this transfer"
    end
  end
end
