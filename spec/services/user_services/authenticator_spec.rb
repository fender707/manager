require 'rails_helper'

describe UsersServices::Authenticator do
  describe '#perform' do
    let(:authenticator) { described_class.new('sample_code') }

    subject { authenticator.perform }

    context 'when code is incorrect' do
      let(:google_error_response) { instance_double(HTTParty::Response, parsed_response: { 'error' => 'bad_verification_code' }) }

      before do
        allow(HTTParty).to receive(:post).and_return(google_error_response)
      end

      it 'should raise an error' do
        expect{ subject }.to raise_error(UsersServices::Authenticator::AuthenticationError)
        expect(authenticator.user).to be_nil
      end
    end

    context 'when code is correct' do
      let(:user_data) do
        {
          login: 'jsmith1',
          url: 'http://example.com',
          avatar_url: 'http://example.com/avatar',
          name: 'John Smith'
        }
      end

      let(:google_token_success_response) { instance_double(HTTParty::Response, parsed_response: { 'access_token' => 'valid_access_token' }) }
      let(:google_user_success_response) { instance_double(HTTParty::Response, double(code: 200), parsed_response: user_data.to_json) }

      before do
        allow(HTTParty).to receive(:post).and_return(google_token_success_response)
        allow(HTTParty).to receive(:get).and_return(double(code: 200, parsed_response: user_data))
      end

      it 'should save the user when does not exists' do
        expect{ subject }.to change{ User.count }.by(1)
        expect(User.last.name).to eq('John Smith')
      end

      it 'should reuse already registered user' do
        user = create :user, user_data
        expect{ subject }.not_to change{ User.count }
        expect(authenticator.user).to eq(user)
      end
    end
  end
end