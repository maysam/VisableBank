# frozen_string_literal: true

class AccountController < ApplicationController
  def overview
    render json: { balance_cents: 100, transactions: [{}] }
  end
end
