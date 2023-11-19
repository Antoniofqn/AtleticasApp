class CreateClubAthletes < ActiveRecord::Migration[7.0]
  def change
    create_table :club_athletes do |t|
      t.string :name
      t.text :achievements
      t.date :joined_at
      t.date :left_at
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
