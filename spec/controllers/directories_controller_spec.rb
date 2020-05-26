require 'rails_helper'

describe DirectoriesController do
  describe '#index' do
    subject { get :index }

    it 'should return success response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json' do
      create_list :directory, 2
      subject
      Directory.recent.each_with_index do |directory, index|
        expect(json_data[index]['attributes']).to eq({
                                                       "title" => directory.title,
                                                       "parent_directory_id" => directory.parent_directory_id
                                                     })
      end
    end

    it 'should return directories in the proper order' do
      old_directory = create :directory
      newer_directory = create :directory
      subject
      expect(json_data.first['id']).to eq(newer_directory.id.to_s)
      expect(json_data.last['id']).to eq(old_directory.id.to_s)
    end
  end

  describe '#create' do
    subject { post :create }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:access_token) { create :access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: '',
                parent_directory_id: ''
              }
            }
          }
        end

        subject { post :create, params: invalid_attributes }

        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper error json' do
          subject
          expect(json['errors']).to include(
                                      {
                                        "source" => { "pointer" => "/data/attributes/title" },
                                        "detail" =>  "can't be blank"
                                      }
                                    )
        end
      end

      context 'when success request sent' do
        let(:access_token) { create :access_token }
        before { request.headers['authorization'] = "Bearer #{access_token.token}" }

        let(:valid_attributes) do
          {
            'data' => {
              'attributes' => {
                'title' => 'Awesome directory',
                'parent_directory_id' => nil
              }
            }
          }
        end

        subject { post :create, params: valid_attributes }

        it 'should have 201 status code' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should have proper json body' do
          subject
          expect(json_data['attributes']).to include(
                                               valid_attributes['data']['attributes']
                                             )
        end

        it 'should create the directory' do
          expect{ subject }.to change{ Directory.count }.by(1)
        end
      end
    end
  end

  describe '#update' do
    let(:user) { create :user }
    let(:directory) { create :directory, user: user }
    let(:access_token) { user.create_access_token }

    subject { patch :update, params: { id: directory.id } }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when trying to update not owned directory' do
      let(:other_user) { create :user }
      let(:other_directory) { create :directory, user: other_user }

      subject { patch :update, params: { id: other_directory.id } }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: ''
              }
            }
          }
        end

        subject do
          patch :update, params: invalid_attributes.merge(id: directory.id)
        end

        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper error json' do
          subject
          expect(json['errors']).to include(
                                      {
                                        "source" => { "pointer" => "/data/attributes/title" },
                                        "detail" =>  "can't be blank"
                                      }
                                    )
        end
      end

      context 'when success request sent' do
        before { request.headers['authorization'] = "Bearer #{access_token.token}" }

        let(:valid_attributes) do
          {
            'data' => {
              'attributes' => {
                'title' => 'Awesome directory',
                'parent_directory_id' => nil
              }
            }
          }
        end

        subject do
          patch :update, params: valid_attributes.merge(id: directory.id)
        end

        it 'should have 200 status code' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'should have proper json body' do
          subject
          expect(json_data['attributes']).to include(
                                               valid_attributes['data']['attributes']
                                             )
        end

        it 'should update the directory' do
          subject
          expect(directory.reload.title).to eq(
                                            valid_attributes['data']['attributes']['title']
                                          )
        end
      end
    end
  end

  describe '#destroy' do
    let(:user) { create :user }
    let(:directory) { create :directory, user: user }
    let(:access_token) { user.create_access_token }

    subject { delete :destroy, params: { id: directory.id } }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when trying to remove not owned directory' do
      let(:other_user) { create :user }
      let(:other_directory) { create :directory, user: other_user }

      subject { delete :destroy, params: { id: other_directory.id } }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when success request sent' do
        before { request.headers['authorization'] = "Bearer #{access_token.token}" }

        it 'should have 204 status code' do
          subject
          expect(response).to have_http_status(:no_content)
        end

        it 'should have empty json body' do
          subject
          expect(response.body).to be_blank
        end

        it 'should destroy the directory' do
          directory
          expect{ subject }.to change{ user.directories.count }.by(-1)
        end
      end
    end
  end
end