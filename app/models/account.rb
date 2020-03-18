# frozen_string_literal: true

class Account < ApplicationRecord
  validates_presence_of :account_number
  validates :account_number, uniqueness: true
  validates :balance_cents, numericality: { greater_than_or_equal_to: 0 }

  validates :client, with: :validate_accounts

  def validate_accounts
    errors.add(:client, "too much") unless client.accounts.count < 3
  end

  # delegate :credit, through: :client
  def credit
  	client.total_credit + client.accounts.where("balance_cents < 0").pluck(:balance_cents).sum
  end

  belongs_to :client, validate: true
  has_many :transactions, dependent: :destroy
end
