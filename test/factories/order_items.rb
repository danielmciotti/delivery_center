# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    quantity { 1 }
    unit_price { 1.5 }
    full_unit_price { 1.5 }
  end
end
