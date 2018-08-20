class CitiesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @cities = City.all
    render json: @cities, only: [:name]
  end
end
