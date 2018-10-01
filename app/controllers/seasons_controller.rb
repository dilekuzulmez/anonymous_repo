class SeasonsController < ApplicationController
  include WithDurationConcern
  include SeasonsHelper
  before_action :set_season, only: %i[show edit update destroy]
  before_action :authenticate_admin!

  # GET /seasons
  def index
    @seasons = Season.all
  end

  # GET /seasons/1
  def show; end

  # GET /seasons/new
  def new
    @season = Season.new
  end

  # GET /seasons/1/edit
  def edit; end

  # POST /seasons
  def create # rubocop:disable Metrics/MethodLength
    @season = Season.new(season_params)
    respond_to do |format|
      if @season.save
        format.html { redirect_to seasons_path, notice: 'Season was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /seasons/1
  def update # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to seasons_path, notice: 'Season was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.json
  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to seasons_url, notice: 'Season was successfully destroyed.' }
    end
  end

  # rubocop:disable Metrics/LineLength
  def total_price
    render json: show_total_price(params[:home_team_id], params[:ticket_type_id])
  end

  def generate_data
    @season = Season.find(params[:season_id])
    render :index
  end

  private

  def set_season
    @season = Season.includes(:teams).find_by(id: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def season_params
    p = params.fetch(:season, {})
              .permit(:name, :duration_start, :duration_end, :is_active, team_ids: [])
    parse_date_range(:duration, p)
  end
end
