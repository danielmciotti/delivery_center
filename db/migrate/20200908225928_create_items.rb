class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items, id: :uuid do |t|
      t.string :externalCode
      t.string :title
      t.references :order_item, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
