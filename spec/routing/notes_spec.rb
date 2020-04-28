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
  end
end