class StadiumsController < ApplicationController
  before_action :set_stadium, only: %i[show edit update destroy]
  before_action :authenticate_admin!

  # GET /stadiums
  def index
    @stadiums = Stadium.all.order('id desc').page(page_params).includes(:home_team)
  end

  # GET /stadiums/1
  def show; end

  # GET /stadiums/new
  def new
    @stadium = Stadium.new
  end

  # GET /stadiums/1/edit
  def edit; end

  # POST /stadiums
  def create
    @stadium = Stadium.new(stadium_params)

    if @stadium.save
      redirect_to stadiums_path, notice: 'Stadium was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /stadiums/1
  def update
    if @stadium.update(stadium_params)
      redirect_to stadiums_path, notice: 'Stadium was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /stadiums/1
  def destroy
    @stadium.destroy
    redirect_to stadiums_url, notice: 'Stadium was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stadium
    @stadium = Stadium.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def stadium_params
    params.fetch(:stadium, {}).permit(:name, :address, :contact, :team_id, :seatmap, :logo)
  end
end
