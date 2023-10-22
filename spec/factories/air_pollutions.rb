FactoryBot.define do
  factory :air_pollution do
    aqi { rand(1..5) }
    sequence(:dt) { |n| n} 
    components { { "co": rand(1..1000), "no": rand(1..1000), "no2": rand(1..1000), "o3": rand(1..1000), "so2": rand(1..1000), "pm2_5": rand(1..1000), "pm10": rand(1..1000), "nh3": rand(1..1000) } }
    location
  end
end