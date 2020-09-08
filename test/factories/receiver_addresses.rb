# frozen_string_literal: true

FactoryBot.define do
  factory :receiver_address do
    address_line { 'MyString' }
    street_name { 'MyString' }
    street_number { 'MyString' }
    comment { 'MyString' }
    zip_code { 'MyString' }
    latitude { 1.5 }
    longitude { 1.5 }
    receiver_phone { 'MyString' }
    city { '' }
    state { '' }
    country { '' }
    neighborhood { '' }
    shipment { nil }
  end
end
