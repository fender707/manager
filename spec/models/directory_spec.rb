require 'rails_helper'

RSpec.describe Directory, type: :model do
  describe '#validations' do
    it 'test Factory Bot object' do
      expect(build :directory).to be_valid
    end

    it 'should validate the presence of a title' do
      directory = build :directory, title: ''
      expect(directory).not_to be_valid
    end
  end
end
