class CreateBuyers < ActiveRecord::Migration[6.0]
  def change
    create_table :buyers, id: :uuid do |t|
      t.string :external_code
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :email
      t.jsonb :phone
      t.jsonb :billing_info

      t.timestamps
    end
  end
end
