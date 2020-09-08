# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    external_code { 'MyString' }
    store_id { 'MyString' }
    date_created { '2020-09-08 20:30:37' }
    date_closed { '2020-09-08 20:30:37' }
    last_updated { '2020-09-08 20:30:37' }
    total_amount { 1.5 }
    total_shipping { 1.5 }
    total_amount_with_shipping { 1.5 }
    paid_amount { 1.5 }
    expiration_date { '2020-09-08 20:30:37' }
    status { 'MyString' }
    total_shipping { 1.5 }
  end
end
