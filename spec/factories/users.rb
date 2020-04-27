FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:login) { |n| "User #{n}" }
    url { 'https://testtest.com' }
    avatar_url { 'https://testtest.com/avatar' }
    provider { 'google' }
  end
end
