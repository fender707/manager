require "rails_helper"

RSpec.describe NotesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/directories/1/notes").to route_to("notes#index", directory_id: '1')
    end

    it "routes to #all_notes" do
      expect(:get => "/notes").to route_to("notes#all_notes")
    end

    it "routes to #create" do
      expect(:post => "directories/1/notes").to route_to("notes#create", directory_id: '1')
    end

    it "routes to #update" do
      expect(:patch => "directories/1/notes/1").to route_to("notes#update", directory_id: '1', id: '1')
    end

    it 'should route to notes destroy' do
      expect(delete '/directories/1/notes/1').to route_to('notes#destroy', directory_id: '1', id: '1')
    end
  end
end