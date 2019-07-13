random_status = ["pending", "ongoing", "done"]
random_priority = ["low", "mid", "high"]

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    start_time { Faker::Time.between(DateTime.now - 3.day, DateTime.now - 2.day) }
    end_time { Faker::Time.between(DateTime.now - 1.day, DateTime.now) }
    priority { random_priority.sample }
    status { random_status.sample }
    description { Faker::Lorem.paragraph }
    user_id { User.first.id }
  end
end
