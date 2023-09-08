class CreateClubs < ActiveRecord::Migration[7.0]
  def change
    create_table :clubs do |t|
      t.string :name, null: false
      t.string :slug
      t.string :logo_url
      t.string :description
      t.integer :year_of_foundation

      t.references :university, null: false, foreign_key: true
      t.timestamps
    end
  end
end
