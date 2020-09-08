# frozen_string_literal: true

class Api::V1::OrdersController < ApplicationController
  def create
    debugger

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
    params.dig(:payments).collect do |payment|
      {
        type: payment[:payment_type],
        value: payment[:total_paid_amount]
      }
    end
  end

  def build_items_hash(params)
    params.dig(:order_items).collect do |item|
      {
        externalCode: item[:item][:id],
        name: item[:item][:title],
        price: item[:unit_price],
        quantity: item[:quantity],
        total: item[:full_init_price],
        subitems: []
      }
    end
  end

  def build_customer_hash(params)
    customer = params.dig(:buyer)

    {
      externalCode: customer[:id],
      name: customer[:first_name].upcase + customer[:last_name].upcase,
      email: customer[:email],
      contact: customer[:phone][:number]
    }
  end

  def build_shipping_hash(params)
    receiver_address = params.dig(:shipping, :receiver_address)

    {
      country: receiver_address.dig(:country, :name),
      state: receiver_address.dig(:state, :name),
      city: receiver_address.dig(:city, :name),
      district: receiver_address.dig(:neighborhood, :name),
      stret: receiver_address.dig(:street_name),
      complement: receiver_address.dig(:comment),
      postalCode: receiver_address.dig(:zip_code)
    }
  end

  def build_order(params)
    {
      externalCode: params[:id],
      storeId: params[:store_id],
      subTotal: params[:total_amount].to_s,
      deliveryFee: params[:total_shipping],
      total: params[:paid_amount].to_s,
      dtOrderCreate: DateTime.now.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
      number: "0", # HUM
      customer: build_customer_hash(params),
      items: build_items_hash(params),
      payments: build_payment_hash(params)
    }.merge(fetch_coordinates_from_state(params.dig(:shipping, :receiver_address, :state, :name)))
     .merge(build_shipping_hash(params))
  end

  def fetch_coordinates_from_state(state)
    latitude, longitude = Geocoder.search(state).first.coordinates

    {
      latitude: latitude,
      longitude: longitude
    }
  end

  def request_time
    DateTime.now.strftime('%Hh%M - %d/%m/%y')
  end

  def send_response(body)
    Typhoeus.post(ENV['DELIVERY_CENTER_ENDPOINT'], body: body, headers: {'X-Sent' => request_time})
  end
end
