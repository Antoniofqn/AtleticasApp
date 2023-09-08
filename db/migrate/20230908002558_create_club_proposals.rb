class CreateClubProposals < ActiveRecord::Migration[7.0]
  def change
    create_table "club_proposals", force: :cascade do |t|
      # Club related fields
      t.string "proposed_club_name", null: false
      t.string "proposed_club_description"
      t.integer "proposed_club_year_of_foundation"
      t.references :university, foreign_key: true
      t.string "proposed_club_logo_url"

      # User related fields (for the user to be created upon approval)
      t.string "proposer_first_name"
      t.string "proposer_last_name"
      t.string "proposer_email", null: false

      # Any other fields related to the approval process
      t.boolean "approved", default: false
      t.datetime "approved_at"
      t.string "remarks" # Any comments or feedback on the proposal

      t.index ["proposer_email"], name: "index_club_proposals_on_proposer_email", unique: true

      t.timestamps
    end
  end
end
