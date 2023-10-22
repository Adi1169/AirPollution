FactoryBot.define do
  factory :location do
    name { "Name" }
    state { "State" }
    country { "Country" }
    lat { rand(1..90) }
    lon { rand(1..180) }
  end
end