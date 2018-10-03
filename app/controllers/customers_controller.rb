class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy points_history notifications_history]
  before_action :authenticate_admin!, except: [:my_profile, :update]
  before_action :authenticate_customer!, only: [:my_profile]
  layout 'blank', only: [:my_profile]

  def my_profile; end
  # GET /customers
  def index
    @customers = CustomerSortService.new.sort_by_spending
    @customers = Kaminari.paginate_array(@customers).page(page_params)
  end

  def export
    csv = ExportCsvService.new(Customer).export_customer
    respond_to do |format|
      format.csv { send_data csv, filename: "customers-#{Date.today}.csv" }
    end
  end

  # GET /customers/1
  def show; end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit; end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path, notice: 'Customer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /customers/1
  def update
    if admin_signed_in?
      if @customer.update(customer_params)
        redirect_to customers_path, notice: 'Customer was successfully updated.'
      else
        render :edit
      end
    elsif customer_signed_in?
      if current_customer.update(customer_params)
        redirect_to my_profile_path, notice: 'Your profile was successfully updated.'
      end
    end
  end

  # DELETE /customers/1
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
    end
  end

  # GET /import
  def import; end

  # POST /bulk_create
  def bulk_create
    import_service = ImportCustomerService.new.execute(import_params[:file], current_admin)
    flash[:info] = import_service

    redirect_to import_customers_path
  end

  def points_history
    @histories = @customer.history_points.includes(:survey, :loyalty_point_rule, :order)
                          .order('created_at DESC')
  end

  def notifications_history
    @histories = @customer.noti_histories.order('created_at DESC')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.fetch(:customer, {}).permit(
      :email,
      :first_name,
      :last_name,
      :phone_number,
      :gender,
      :birthday,
      :point,
      address: %i[city district street ward]
    )
  end

  def import_params
    params.permit(:file, :utf8, :authenticity_token, :button)
  end
end
