class Shipment < ApplicationRecord
  belongs_to :order

  has_one :receiver_address
end
