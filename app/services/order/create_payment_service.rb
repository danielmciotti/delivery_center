# frozen_string_literal: true

class Order::CreatePaymentService < BaseOrderService
  def initialize(order_id, params)
    return unless params.key? :payments

    super
  end

  def execute
    Payment.create!(params.map { |pp| pp.merge(order: order) })
  end

  private

  def permitted_params(params)
    params.require(:payments).collect do |payment|
      payment.permit(model_permitted_params)
    end
  end

  def model_permitted_params
    %i[
      id payer_id installments payment_type status transaction_amount taxes_amount shipping_cost
      total_paid_amount installment_amount date_approved date_created
    ]
  end
end
