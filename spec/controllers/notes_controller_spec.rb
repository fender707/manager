require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  let(:directory) { create :directory }

  describe "GET #all_notes" do
    subject { get :all_notes }

    it "returns a success response" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return all notes belonging to user' do
      user = create :user
      note = create :note, directory: directory, user: user
      second_note = create :note, user: user
      subject
      expect(json_data.length).to eq(2)
      expect(json_data.first['id']).to eq(note.id.to_s)
      expect(json_data.second['id']).to eq(second_note.id.to_s)
    end

    it 'should have proper json body' do
      user = create :user
      note = create :note, directory: directory, user: user
      second_note = create :note, user: user
      subject
      expect(json_data.first['attributes']).to eq({
                                                    'title' => note.title,
                                                    'description' => note.description,
                                                    'tags' => note.tags,
                                                    'position' => note.position
                                                  })
      expect(json_data.second['attributes']).to eq({
                                                    'title' => second_note.title,
                                                    'description' => second_note.description,
                                                    'tags' => second_note.tags,
                                                    'position' => second_note.position
                                                  })
    end
  end

  describe "GET #index" do
    subject { get :index, params: { directory_id: directory.id } }

    it "returns a success response" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return only notes belonging to directory' do
      note = create :note, directory: directory
      create :note
      subject
      expect(json_data.length).to eq(1)
      expect(json_data.first['id']).to eq(note.id.to_s)
    end

    it 'should have proper json body' do
      note = create :note, directory: directory, position: 1
      subject
      expect(json_data.first['attributes']).to eq({
                                                    'title' => note.title,
                                                    'description' => note.description,
                                                    'tags' => [],
                                                    'position' => 1
                                                  })
    end

    it 'should have related objects information in the response' do
      user = create :user
      create :note, directory: directory, user: user
      subject
      relationships = json_data.first['relationships']
      expect(relationships['directory']['data']['id']).to eq(directory.id.to_s)
      expect(relationships['user']['data']['id']).to eq(user.id.to_s)
    end
  end

  describe "POST #create" do
    context 'when not authorized' do
      subject { post :create, params: { directory_id: directory.id } }

      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:valid_attributes) do
        { data: { attributes: { title: 'Note 1', description: 'My awesome note for directory', tags: [], position: 1 } } }
      end

      let(:invalid_attributes) { { data: { attributes: { title: '' } } } }

      let(:user) { create :user }
      let(:access_token) { user.create_access_token }

      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context "with valid params" do
        subject do
          post :create, params: valid_attributes.merge(directory_id: directory.id)
        end

        it 'returns 201 status code' do
          subject
          expect(response).to have_http_status(:created)
        end

        it "creates a new Note" do
          expect { subject }.to change(directory.notes, :count).by(1)
        end

        it "renders a JSON response with the new note" do
          subject
          expect(json_data['attributes']).to eq({
                                                  'title' => 'Note 1',
                                                  'description' => 'My awesome note for directory',
                                                  'tags' => [],
                                                  'position' => 1
                                                })
        end
      end

      context "with invalid params" do
        subject do
          post :create, params: invalid_attributes.merge(directory_id: directory.id)
        end

        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "renders a JSON response with errors for the new comment" do
          subject
          expect(json['errors']).to include({
                                              "source" => { "pointer" => "/data/attributes/title" },
                                              "detail" =>  "can't be blank"
                                            })
        end
      end
    end

  end
end