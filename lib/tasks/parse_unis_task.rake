namespace :data do
  desc "Parse University Data to Populate DB"
  task parse_unis: :environment do
    CSV.foreach(Rails.root.join('data', 'universities.csv'), headers: true) do |row|
      attributes = row.to_hash
      attributes["category"] == "0" ? attributes["category"] = :public : attributes["category"] = :private
      University.find_or_create_by!(attributes)
    end
  end
end
