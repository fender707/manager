FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { '' }
    trait :with_google_login do
      transient do
        provider { 'google' }
        uid { '11213777880287' }
        after(:create) do |user, eval|
          user.logins.create(provider: eval.provider,
                             uid: eval.uid,
                             identification: 'identification')
        end
      end
    end
  end
end
