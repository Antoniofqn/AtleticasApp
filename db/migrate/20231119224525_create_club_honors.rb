class CreateClubHonors < ActiveRecord::Migration[7.0]
  def change
    create_table :club_honors do |t|
      t.string :title
      t.integer :year
      t.text :description
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
