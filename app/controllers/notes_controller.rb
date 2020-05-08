class NotesController < ApplicationController
  before_action :authorize!, only: %i[create update]

  before_action :load_directory, except: %i[all_notes]

  def all_notes
    all_notes = Note.all
    render json: all_notes
  end

  def index
    notes = @directory.notes
    render json: notes
  end

  def show
    render json: @directory.notes.find(params[:id])
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

  def update
    note = @directory.notes.find(params[:id])
    note.update_attributes!(note_params)
    render json: note, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
    render json: note, adapter: :json_api,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end


  def destroy
    note = @directory.notes.find(params[:id])
    note.destroy
    head :no_content
  rescue
    authorization_error
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