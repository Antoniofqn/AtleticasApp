class ChangeColumnInClubAthlete < ActiveRecord::Migration[7.0]
  def up
    # Convert integer to timestamp, then to date
    change_column :club_athletes, :joined_at, 'timestamp without time zone USING TO_TIMESTAMP(joined_at)'
    change_column :club_athletes, :joined_at, :date

    change_column :club_athletes, :left_at, 'timestamp without time zone USING TO_TIMESTAMP(left_at)'
    change_column :club_athletes, :left_at, :date
  end

  def down
    # Convert back to integer if needed
    change_column :club_athletes, :joined_at, 'integer USING EXTRACT(EPOCH FROM joined_at)'
    change_column :club_athletes, :left_at, 'integer USING EXTRACT(EPOCH FROM left_at)'
  end
end
