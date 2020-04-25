class DirectoriesController < ApplicationController
  def index
    directories = Directory.recent
    render json: directories
  end

  def show
    directory = Directory.find_by(id: params[:id])
    render json: directory
  end
end
