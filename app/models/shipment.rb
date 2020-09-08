# frozen_string_literal: true

class Shipment < ApplicationRecord
  belongs_to :order

  has_one :receiver_address, dependent: :nullify
end
