class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :product_search, foreign_key: true
      t.jsonb :site_details, default: {}
      t.jsonb :features, default: {}
      t.decimal :price, default: 0.0
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end