class DirectoriesController < ApplicationController
  before_action :authorize!, only: %i[create update destroy]

  def index
    directories = Directory.recent
    render json: directories
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
end
