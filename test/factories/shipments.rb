# frozen_string_literal: true

FactoryBot.define do
  factory :shipment do
    external_code { 'MyString' }
    shipment_type { 'MyString' }
    date_created { '2020-09-08 20:18:56' }
  end
end
