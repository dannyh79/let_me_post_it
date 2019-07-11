random_status = ["pending", "ongoing", "done"]
random_priority = ["low", "mid", "high"]

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    start_time { Faker::Time.between(DateTime.now - 3, DateTime.now - 2) }
    end_time { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    priority { random_priority.sample }
    status { random_status.sample }
    description { Faker::Lorem.paragraph }
  end
end
