# frozen_string_literal: true

class TransactionController < ApplicationController
  def transfer
    source = Account.find_by_account_number params[:from]
    destination = Account.find_by_account_number params[:to]
    amount = params[:amount].to_i
    user_description = params[:user_description]

    if source.nil?
      return render status: :not_found, body: 'Sender account number is invalid'
    end
    if destination.nil?
      return render status: :not_found, body: 'Receiver account number is invalid'
    end

    if amount <= 0
      render status: :precondition_failed, body: 'Positive amount value is required'
    elsif source.balance_cents < amount
      render status: :precondition_failed, body: "Available funds don't cover this transfer"
    else
      Transaction.transaction do
        Account.lock.find(source.id, destination.id)
        # locking both accounts

        source.balance_cents -= amount
        source.save!

        params = {
          sent_cents: amount,
          balance_cents: source.balance_cents,
          user_description: user_description,
          system_description: "sent to '#{destination.account_number}'"
        }
        source.transactions.create! params

        destination.balance_cents += amount
        destination.save!

        params = {
          received_cents: amount,
          balance_cents: destination.balance_cents,
          user_description: user_description,
          system_description: "received from '#{source.account_number}'"
        }
        destination.transactions.create! params

        head :ok
      end
  end
  end
end
