require 'rails_helper'

RSpec.describe User, type: :model do
  context 'FactoryBot subject' do
    it { expect(create :user).to be_valid }
  end
  context 'associations' do
    it { expect(subject).to have_many(:directories).dependent(:destroy) }
    it { expect(subject).to have_one(:access_token).dependent(:destroy) }
  end
  context 'validations' do
    it 'requires login' do
      user = build :user, login: ''
      expect(user).to_not be_valid
      expect(user.errors.messages[:login]).to include("can't be blank")
    end
    it 'requires provider' do
      user = build :user, provider: ''
      expect(user).to_not be_valid
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end
    it 'requires uniqueness of login' do
      user = create :user
      duplicated_user = build :user, login: user.login
      expect(duplicated_user).to_not be_valid
      expect(duplicated_user.errors.messages[:login]).to include("has already been taken")
      duplicated_user.login = 'newlogin'
      expect(duplicated_user).to be_valid
    end
  end
end
