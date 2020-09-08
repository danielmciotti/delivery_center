class CreateReceiverAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :receiver_addresses, id: :uuid do |t|
      t.string :address_line
      t.string :street_name
      t.string :street_number
      t.string :comment
      t.string :zip_code
      t.float :latitude
      t.float :longitude
      t.string :receiver_phone
      t.jsonb :city
      t.jsonb :state
      t.jsonb :country
      t.jsonb :neighborhood
      t.references :shipment, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
