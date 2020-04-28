require 'rails_helper'

RSpec.describe Note, type: :model do
  context 'associations' do
    it { expect(subject).to belong_to(:user) }
    it { expect(subject).to belong_to(:directory) }
  end
  describe 'validations' do
    it 'should have valid factory' do
      expect(build :note).to be_valid
    end

    it 'should test presence of attributes' do
      note = Note.new
      expect(note).not_to be_valid
      expect(note.errors.messages).to include({
                                                user: ['must exist'],
                                                directory: ['must exist'],
                                                title: ["can't be blank"]
                                              })
    end
  end
end