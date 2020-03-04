# frozen_string_literal: true

class Account < ApplicationRecord
  validates_presence_of :account_number
  validates :account_number, uniqueness: true
  validates :balance_cents, numericality: { greater_than_or_equal_to: 0 }

  has_many :transactions, dependent: :destroy
end
