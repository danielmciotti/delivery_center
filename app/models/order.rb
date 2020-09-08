class Order < ApplicationRecord
  has_many :order_items
  has_many :payments

  has_one :shipment
  has_one :buyer
end
