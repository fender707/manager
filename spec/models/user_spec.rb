require 'rails_helper'

RSpec.describe User, type: :model do
  context 'FactoryBot subject' do
    it { expect(create :user).to be_valid }
    it { expect(create :user, :with_google_login).to be_valid }
  end
  context 'associations' do
    it { expect(subject).to have_many(:logins).dependent(:destroy) }
    it { expect(subject).to have_many(:directories).dependent(:destroy) }
  end
end
