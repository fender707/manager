class NotesController < ApplicationController
  before_action :authorize!, only: %i[create]

  before_action :load_directory, only: %i[index create]

  def all_notes
    all_notes = Note.all
    render json: all_notes
  end

  def index
    notes = @directory.notes
    render json: notes
  end

  def create
    @note = @directory.notes.build(
      note_params.merge(user: current_user)
    )

    @note.save!
    render json: @note, status: :created, location: @directory
  rescue
    render json: @note, adapter: :json_api,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end

  private

  def load_directory
    @directory = Directory.find(params[:directory_id])
  end

  def note_params
    params.require(:data).require(:attributes).
      permit(:title, :description, :tags, :position) ||
      ActionController::Parameters.new
  end
end