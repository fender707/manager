class DirectoriesController < ApplicationController
  before_action :authorize!, only: %i[create update destroy update_notes_positions]

  def index
    directories = Directory.recent
    render json: directories
  end

  def show
    render json: Directory.find(params[:id])
  end

  def create
    directory = current_user.directories.build(directory_params)
    directory.save!
    render json: directory, status: :created
  rescue
    render json: directory, adapter: :json_api,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end

  def update
    directory = current_user.directories.find(params[:id])
    directory.update_attributes!(directory_params)
    render json: directory, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
    render json: directory, adapter: :json_api,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end

  def update_notes_positions
    directory = current_user.directories.includes(:notes).find(params[:id])
    notes_positions_params[:orderedNotes].each_with_index do |note_id, index|
      note = directory.notes.find { |note| note.id == note_id.to_i }
      note.update(position: index+1)
    end
    render json: directory.notes.reload, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
    render json: directory, adapter: :json_api,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end

  def destroy
    directory = current_user.directories.find(params[:id])
    directory.destroy
    head :no_content
  rescue
    authorization_error
  end

  private

  def directory_params
    params.require(:data).require(:attributes).
      permit(:title, :parent_directory_id) ||
      ActionController::Parameters.new
  end

  def notes_positions_params
    params.require(:data).permit(orderedNotes: []) ||
      ActionController::Parameters.new
  end
end
