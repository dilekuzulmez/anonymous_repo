class ZonesController < ApplicationController
  before_action :set_stadium
  before_action :set_zone, only: %i[show edit update destroy]

  # GET /zones
  def index
    @zones = @stadium.zones.order('id desc')
  end

  # GET /zones/1
  def show; end

  # GET /zones/new
  def new
    @zone = Zone.new
  end

  # GET /zones/1/edit
  def edit; end

  # POST /zones
  def create
    @zone = @stadium.zones.new(zone_params)

    if @zone.save
      redirect_to stadium_zones_path(@stadium), notice: 'Zone was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /zones/1
  def update
    if @zone.update(zone_params)
      redirect_to stadium_zones_path(@stadium), notice: 'Zone was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /zones/1
  def destroy
    @zone.destroy
    redirect_to stadium_zones_path(@stadium), notice: 'Zone was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_zone
    @zone = @stadium.zones.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def zone_params
    params.fetch(:zone, {}).permit(
      :stadium_id,
      :gate_id,
      :code,
      :description,
      :price,
      :capacity,
      :zone_type,
      :image
    )
  end

  def set_stadium
    @stadium = Stadium.friendly.find(params[:stadium_id])
  end
end
