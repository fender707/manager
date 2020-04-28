FactoryBot.define do
  factory :note do
    sequence(:title) { |n| "Note #{n}" }
    description { 'Note Description' }
    sequence(:position) { |n| n }
    tags { [] }
    directory
    user
  end
end
