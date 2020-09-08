class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.string :external_code
      t.string :store_id
      t.datetime :date_created
      t.datetime :date_closed
      t.datetime :last_updated
      t.float :total_amount
      t.float :total_shipping
      t.float :total_amount_with_shipping
      t.float :paid_amount
      t.datetime :expiration_date
      t.string :status

      t.timestamps
    end

    add_reference :payments, :orders, foreign_key: true, type: :uuid
    add_reference :buyers, :orders, foreign_key: true, type: :uuid
    add_reference :shipments, :orders, foreign_key: true, type: :uuid
    add_reference :order_items, :orders, foreign_key: true, type: :uuid
  end
end
