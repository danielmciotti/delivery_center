# frozen_string_literal: true

class Api::V1::OrdersController < ApplicationController
  def create
    debugger
  end

  private

  def permitted_params
    params.require(:order).permit(order_permitted_params,
                                  payments: [payment_permitted_params],
                                  buyer: buyer_permitted_params,
                                  order_items: order_items_permitted_params,
                                  shipping: shipment_permitted_params)
  end

  def order_permitted_params
    %i[id store_id date_created date_closed last_updated total_amount total_shipping
       total_amount_with_shipping paid_amount expiration_date total_shipping status]
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
      {phone: %i[area_code number],
       billing_info: %i[doc_type doc_number]}
    ]
  end

  def order_items_permitted_params
    [:quantity, :unit_price, :full_unit_price, {item: %i[id title]}]
  end

  def shipment_permitted_params
    [
      :id, :shipment_type, :date_created,
      {receiver_address: [
        :id, :address_line, :street_name, :street_number, :comment, :zip_code, :latitude, :longitude, :receiver_phone,
        {city: :name,
         state: :name,
         country: %i[id name],
         neighborhood: %i[id name]}
      ]}
    ]
  end
end
