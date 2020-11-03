# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_token
  validates :name, presence: true, length: { maximum: 10 }, uniqueness: { case_sensitive: false }

  has_many :items, dependent: :destroy
end
