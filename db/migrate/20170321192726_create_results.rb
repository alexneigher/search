class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :product_search, foreign_key: true
      t.jsonb :site_details, null: false, default: {}
      t.jsonb :features, null: false, default: {}
      t.decimal :price, default: 0.0
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end