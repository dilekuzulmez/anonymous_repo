class LoginCustomerService
  # provider can be FacebookService or ZaloService in the future
  def initialize(provider)
    @new_customer = false
    @provider = provider
  end

  def execute
    @customer_data = @provider.execute

    # regenerate token if login again
    if customer.persisted?
      customer.regenerate_access_token
    else
      @new_customer = true
      customer.assign_attributes(@customer_data.except(:uid, :provider))
      customer.save
      identity.update_attributes(customer_id: customer.id)
    end
  end

  def new_customer?
    @new_customer
  end

  def identity
    @identity ||= Identity.find_or_create_by(
      uid: @customer_data[:uid],
      provider: @customer_data[:provider]
    )
  end

  def customer
    @customer ||= identity.customer.present? ? identity.customer : Customer.new
  end
end
