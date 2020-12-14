FactoryBot.define do

  factory :user do
    name{'factory'}
    email{'factory@railstutorial.org'}
    password{'password'}
    password_confirmation{'password'}

    trait :admin do
      admin{true}
    end

    trait :activated do
      activated{true}
      activated_at{Time.zone.now}
    end

    trait :other do
      name{'other'}
      email{'other@railstutorial.org'}
      activated{true}
      activated_at{Time.zone.now}
    end
    
    trait :michael do
      name{'michael'}
      email{'michael@railstutorial.org'}
      activated{true}
      activated_at{Time.zone.now}
    end
    
  end

end
