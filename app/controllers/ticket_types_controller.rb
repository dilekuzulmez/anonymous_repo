class TicketTypesController < ApplicationController
  include SeasonsHelper
  before_action :set_match, except: [:season]
  before_action :set_ticket_type, only: %i[show edit update destroy]
  before_action :authenticate_admin!

  def index
    @ticket_types = @match.ticket_types
  end

  def show; end

  def new
    @ticket_type = TicketType.new
  end

  def edit; end

  def create
    @ticket_type = @match.ticket_types.new(ticket_type_params)

    respond_to do |format|
      if @ticket_type.save
        format.html { redirect_to after_update_path, notice: 'Ticket type was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @ticket_type.update(ticket_type_params)
        format.html { redirect_to after_update_path, notice: 'Ticket type was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @ticket_type.destroy

    respond_to do |format|
      format.html { redirect_to after_update_path, notice: 'Ticket type was successfully destroyed.' }
    end
  end
  # rubocop:disable Metrics/LineLength

  def season
    home_team_match = Match.current_season_with_home_team(params[:team_id], current_season(params[:league_id])).first
    return nil unless home_team_match
    @ticket_types = home_team_match.ticket_types
    render :index
  end

  private

  def after_update_path
    match_ticket_types_path(@match)
  end

  def set_match
    @match = Match.find(params[:match_id])
  end

  def set_ticket_type
    @ticket_type = @match.ticket_types.friendly.find(params[:id])
  end

  def ticket_type_params
    params.fetch(:ticket_type, {}).permit(:code, :class_type, :quantity, :price, :benefit)
  end
end
