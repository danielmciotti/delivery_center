# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order

  has_many :items, dependent: :nullify
end
