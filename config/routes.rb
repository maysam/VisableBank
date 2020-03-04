# frozen_string_literal: true

Rails.application.routes.draw do
  get 'account/:account_number/overview', to: 'account#overview', as: 'account_overview'
  post 'transaction/transfer'
end
