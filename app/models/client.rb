class Client < ApplicationRecord
  validates :accounts, length: { maximum: 3 }

  has_many :accounts, validate: true
end
