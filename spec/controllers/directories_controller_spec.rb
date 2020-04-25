require 'rails_helper'

describe DirectoriesController do

  describe '#index' do
    subject { get :index }
    it 'should return success response' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'should return proper json' do
      create_list :directory, 2
      subject
      Directory.recent.each_with_index { |directory, index|
        expect(json_data[index]['attributes']).to eq({
                                           'title' => directory.title,
                                           'parent-directory-id' => nil
                                         })
      }

    end

    it 'should return directories in proper order' do
      old_directory = create :directory
      newer_directory = create :directory
      subject
      expect(json_data.first['id']).to eq(newer_directory.id.to_s)
      expect(json_data.second['id']).to eq(old_directory.id.to_s)
    end
  end

  describe '#show' do
    let(:directory) { create :directory }
    subject { get :show, params: { id: directory.id } }

    it 'should return success response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json' do
      subject
      expect(json_data['attributes']).to eq({
                                              "title" => directory.title,
                                              "parent-directory-id" => nil
                                            })
    end
  end

end