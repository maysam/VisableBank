# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy
end
