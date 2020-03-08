# frozen_string_literal: true

class BankingService
  def self.account_overview(account)
    {
      balance_cents: account.balance_cents,
      transactions: account.transactions.order(id: :desc).first(10)
    }
  end

  def self.transfer_funds(source, destination, amount, _description)
    Transaction.transaction do
      Account.lock.find(source.id, destination.id)
      # locking both accounts

      source.balance_cents -= amount
      source.save!

      params = {
        sent_cents: amount,
        balance_cents: source.balance_cents,
        user_description: _description,
        system_description: "sent to '#{destination.account_number}'"
      }
      source.transactions.create! params

      destination.balance_cents += amount
      destination.save!

      params = {
        received_cents: amount,
        balance_cents: destination.balance_cents,
        user_description: _description,
        system_description: "received from '#{source.account_number}'"
      }
      destination.transactions.create! params
    end
  end
end
