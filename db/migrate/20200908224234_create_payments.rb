class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :payments, id: :uuid do |t|
      t.string :external_code
      t.string :status
      t.string :payment_type
      t.string :payer_id
      t.integer :installments
      t.float :transaction_amount
      t.float :taxes_amount
      t.float :shipping_cost
      t.float :total_paid_amount
      t.float :installment_amount
      t.datetime :date_approved
      t.datetime :date_created

      t.timestamps
    end
  end
end
