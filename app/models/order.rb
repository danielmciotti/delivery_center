# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items, dependent: :nullify
  has_many :payments, dependent: :nullify

  has_one :shipment, dependent: :nullify
  has_one :buyer, dependent: :nullify
end
