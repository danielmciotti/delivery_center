class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items, id: :uuid do |t|
      t.integer :quantity
      t.float :unit_price
      t.float :full_unit_price
      t.jsonb :item

      t.timestamps
    end
  end
end
