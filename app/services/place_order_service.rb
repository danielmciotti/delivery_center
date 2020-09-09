# frozen_string_literal: true

class PlaceOrderService < BaseService
  attr_accessor :order

  def initialize(order_id)
    return if order_id.nil?

    self.order = Order.find_by(id: order_id)
  end

  def execute
    Typhoeus::PostRequestService.call(build_response)
  end

  private

  def build_response
    {
      externalCode: order.external_code,
      storeId: order.store_id,
      subTotal: order.total_amount,
      total: order.paid_amount,
      dtOrderCreate: DateTime.now.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
      number: '0',
      customer: customer_reponse,
      items: items_response,
      payments: payment_response
    }.merge(receiver_address_response)
  end

  def customer_reponse
    buyer = order.buyer

    {
      externalCode: buyer.external_code,
      name: buyer.first_name.upcase.concat(' ', buyer.last_name.upcase),
      email: buyer.email,
      contact: buyer.phone['number']
    }
  end

  def payment_response
    order.payments.collect do |payment|
      {
        value: payment.total_paid_amount,
        type: payment.payment_type
      }
    end
  end

  def items_response
    order.order_items.collect do |oi|
      {
        externalCode: oi.item['external_code'],
        name: oi.item['title'],
        price: oi.unit_price,
        quantity: oi.quantity,
        total: oi.full_unit_price,
        subItems: []
      }
    end
  end

  def receiver_address_response
    ra = order.shipment.receiver_address

    {
      latitude: ra.latitude,
      longitude: ra.longitude,
      country: ra.country['name'],
      state: ra.state['id'],
      city: ra.city['name'],
      district: ra.neighborhood['name'],
      street: ra.street_name,
      complement: ra.comment,
      postalCode: ra.zip_code
    }
  end
end
