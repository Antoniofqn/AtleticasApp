class CreateClubContents < ActiveRecord::Migration[7.0]
  def change
    create_table :club_contents do |t|
      t.text :content
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
