class CreateUniversities < ActiveRecord::Migration[7.0]
  def change
    create_table :universities do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.string :region, null: false
      t.integer :category, null: false
      t.string :abbreviation, null: false
      t.string :slug
      t.string :logo_url

      t.timestamps
    end
  end
end
