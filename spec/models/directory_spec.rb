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


  describe '.recent' do
    it 'should list recent directory first' do
      old_directory = create :directory
      newer_directory = create :directory
      expect(described_class.recent).to eq([newer_directory, old_directory])
      expect(old_directory.update(created_at: Time.now))
      expect(described_class.recent).to eq([old_directory, newer_directory])
    end
  end
end
