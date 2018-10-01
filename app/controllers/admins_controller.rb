class AdminsController < ApplicationController
  before_action :set_admin, only: %i[edit update show]
  before_action :authenticate_admin!

  def index
    @admins = Admin.order(:id).page(page_params)
  end

  def create
    create_admin_params = admin_params.merge(created_by_id: current_admin.id)
    @admin = Admin.new(create_admin_params)
    if @admin.save
      flash[:success] = 'Create account successfully'
      redirect_to admins_path
    else
      render :new
    end
  end

  def new
    @admin = Admin.new
  end

  def edit; end

  def update
    @admin.assign_attributes(admin_params)
    if @admin.save
      flash[:success] = 'Update account successfully'
      redirect_to admins_path
    else
      render :edit
    end
  end

  def show; end

  private

  def admin_params
    params.require(:admin).permit(:email, :first_name, :last_name)
  end

  def set_admin
    @admin = Admin.find(params[:id])
  end
end
