class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy home_stadium]

  def export
    csv = ExportCsvService.new(Team).export_order_by_home_team(params[:id], params[:season_id])
    respond_to do |format|
      format.csv { send_data csv, filename: "team-orders_#{Date.today}.csv" }
    end
  end

  # GET /teams
  def index
    @teams = Team.all.order('id desc').page(page_params)
  end

  # GET /teams/1
  def show
    @upcoming_home_matches = @team.matches_as_home_team.upcoming
    @upcoming_away_matches = @team.matches_as_away_team.upcoming
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit; end

  # POST /teams
  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to teams_path, notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to teams_path, notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end

  def home_stadium
    @stadium = @team.home_stadium
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def team_params
    params.require(:team).permit(:name, :description, :banner, :color_1, :color_2, :code,
                                 :payment_info_vi, :payment_info_en)
  end
end
