FactoryBot.define do
  factory :micropost do
    content{"インリビング"}
    user_id{""}
    video_id{"3ZMuehY9tiE"}

    trait :first do
      content{"first"}
      created_at{ 3.years.ago }
    end
    trait :second do
      content{"second"}
      created_at{ 10.minutes.ago }
    end
    trait :third do
      content{"third"}
      created_at{ Time.zone.now }
    end
  end
end
