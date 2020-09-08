# frozen_string_literal: true

class Api::V1::OrdersController < ApplicationController
  def create
    send_response(build_order(permitted_params))
  end

  private

  def permitted_params
    params.require(:order)
      .permit(order_permitted_params,
              payments: [payment_permitted_params],
              buyer: buyer_permitted_params,
              order_items: order_items_permitted_params,
              shipping: shipment_permitted_params).to_h
  end

  def order_permitted_params
    %i[
      id store_id date_created date_closed last_updated total_amount total_shipping
      total_amount_with_shipping paid_amount expiration_date total_shipping status
    ]
  end

  def payment_permitted_params
    %i[
      id order_id payer_id installments payment_type status transaction_amount taxes_amount shipping_cost
      total_paid_amount installment_amount date_approved date_created
    ]
  end

  def buyer_permitted_params
    [
      :id, :nickname, :email, :phone, :first_name, :last_name, :billing_info,
      {
        phone: %i[area_code number],
        billing_info: %i[doc_type doc_number]
      }
    ]
  end

  def order_items_permitted_params
    [
      :quantity, :unit_price, :full_unit_price,
      {
        item: %i[id title]
      }
    ]
  end

  def shipment_permitted_params
    [
      :id, :shipment_type, :date_created,
      {
        receiver_address: [
          :id, :address_line, :street_name, :street_number, :comment, :zip_code, :latitude, :longitude, :receiver_phone,
          {
            city: :name,
            state: :name,
            country: %i[id name],
            neighborhood: %i[id name]
          }
        ]
      }
    ]
  end

  def build_payment_hash(params)
    params[:payments].collect do |payment|
      {
        type: payment[:payment_type],
        value: payment[:total_paid_amount]
      }
    end
  end

  def build_items_hash(params)
    params[:order_items].collect do |item|
      {
        externalCode: item[:item][:id],
        name: item[:item][:title],
        price: item[:unit_price],
        quantity: item[:quantity],
        total: item[:full_unit_price],
        subItems: []
      }
    end
  end

  def build_customer_hash(params)
    customer = params[:buyer]

    {
      externalCode: customer[:id].to_s,
      name: customer[:first_name].upcase.concat(' ', customer[:last_name].upcase),
      email: customer[:email],
      contact: customer[:phone][:number]
    }
  end

  def build_shipping_hash(params)
    receiver_address = params.dig(:shipping, :receiver_address)

    {
      city: receiver_address.dig(:city, :name),
      district: receiver_address.dig(:neighborhood, :name),
      street: receiver_address[:street_name],
      complement: receiver_address[:comment],
      postalCode: receiver_address[:zip_code]
    }
  end

  def build_order(params)
    state = params.dig(:shipping, :receiver_address, :state, :name)
    zip = params.dig(:shipping, :receiver_address, :zip_code)

    {
      externalCode: params[:id].to_s,
      storeId: params[:store_id],
      subTotal: params[:total_amount].to_s,
      deliveryFee: params[:total_shipping].to_s,
      total: params[:paid_amount].to_s,
      dtOrderCreate: DateTime.now.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
      number: '0', # HUM
      customer: build_customer_hash(params),
      items: build_items_hash(params),
      payments: build_payment_hash(params)
    }.merge(fetch_location_data_from_state_and_zip(state, zip))
      .merge(build_shipping_hash(params))
  end

  def fetch_location_data_from_state_and_zip(state, zip)
    result = Geocoder.search(state).first
    latitude, longitude = result.coordinates
    response = Typhoeus.get("#{ENV['CEP_ENDPOINT']}#{zip}/json").response_body
    parsed_response = JSON.parse(response)

    {
      latitude: latitude,
      longitude: longitude,
      country: result.country_code.upcase,
      state: parsed_response['uf']
    }
  end

  def request_time
    DateTime.now.strftime('%Hh%M - %d/%m/%y')
  end

  def send_response(body)
    Typhoeus.post(ENV['DELIVERY_CENTER_ENDPOINT'], body: body, headers: {'X-Sent' => request_time})
  end
end
