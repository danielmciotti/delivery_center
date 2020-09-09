# frozen_string_literal: true

class Api::V2::OrdersController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      @order = Order.create!(permitted_params)
      @buyer = Order::CreateBuyerService.call(@order.id, params)
      @payments = Order::CreatePaymentService.call(@order.id, params)
      @shipping = Order::CreateShipmentService.call(@order.id, params)
      @address = Order::CreateDeliveryAddressService.call(@shipping.id, params)
      @order_items = Order::CreateOrderItemsService.call(@order.id, params)

      PlaceOrderService.call(@order.id)
    end
  end

  private

  def permitted_params
    permitted_hash = params.require(:order).permit(order_permitted_params)

    permitted_hash.merge(external_code: permitted_hash[:id])
  end

  def order_permitted_params
    %i[
      id store_id date_created date_closed last_updated total_amount total_shipping
      total_amount_with_shipping paid_amount expiration_date total_shipping status
    ]
  end
end
