  # rubocop:disable all
  class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]

  ALLOWED_FILTERS = %w[upcoming playing played].freeze
  DEFAULT_FILTER = 'upcoming'.freeze

  # GET /matches
  def index
    @matches = matches_query

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /matches/1
  def show; end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit; end

  def create
    @match = create_match_service.execute(match_params)

    if @match.persisted?
      flash[:success] = 'Match was successfully created.'
      redirect_to matches_path
    else
      render :new
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      flash[:success] = 'Match was successfully updated.'
      redirect_to matches_path
    else
      render :edit
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy
    flash[:success] = 'Match was successfully destroyed.'
    redirect_to matches_url
  end

  private

  def create_match_service
    @create_match_service ||= CreateMatchService.new
  end

  def receive_file_service
    @receive_file_service ||= ReceiveFileService.new
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  def import_params
    params.permit(:file, :utf8, :authenticity_token, :button)
  end

  def match_params
    params.fetch(:match, {}).permit(
      :name,
      :season_id,
      :home_team_id,
      :away_team_id,
      :stadium_id,
      :start_time,
      :round,
      :home_team_score,
      :away_team_score,
      :seat_selection,
      :active
    )
  end

  def match_filter
    # set back to default if receiving unknown value
    @match_filter = ALLOWED_FILTERS.include?(params[:filter]) ? params[:filter] : DEFAULT_FILTER
  end

  def matches_query
    query = Match.all
              .public_send(match_filter)
              .order('start_time asc')
              .includes(:stadium, :home_team, :away_team, :season)
              .page(page_params)

    query = query.in_season(params[:season]) if params[:season].present?
    query
  end
end
