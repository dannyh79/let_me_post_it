random_status = ["pending", "ongoing", "done"]

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    start_time { Faker::Time.between(DateTime.now - 3, DateTime.now - 2) }
    end_time { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    priority { 1 }
    status { random_status.sample }
    description { Faker::Lorem.paragraph }
  end
end
