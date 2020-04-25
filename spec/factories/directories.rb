FactoryBot.define do
  factory :directory do
    sequence(:title) { |n| "Directory #{n}" }
    parent_directory_id { nil }
  end
end
