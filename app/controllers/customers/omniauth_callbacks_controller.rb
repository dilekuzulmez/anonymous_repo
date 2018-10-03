module Customers
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def google_oauth2
      auth = request.env['omniauth.auth']

      @customer = Customer.find_or_create_by(email: auth.info.email)
      if @customer.update_from_oauth(auth)
        flash[:info] = "You have logged in"
        sign_in_and_redirect @customer, event: :authentication
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
