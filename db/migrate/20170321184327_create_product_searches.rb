class CreateProductSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :product_searches do |t|
      t.string :query
      t.date :cached_at

      t.timestamps
    end
  end
end
