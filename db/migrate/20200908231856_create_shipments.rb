class CreateShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :shipments, id: :uuid do |t|
      t.string :external_code
      t.string :shipment_type
      t.datetime :date_created

      t.timestamps
    end
  end
end
