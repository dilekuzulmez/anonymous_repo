module Admins
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def sign_in_with(_provider_name)
      auth = request.env['omniauth.auth']

      @admin = Admin.find_by(email: auth.info.email)

      if @admin
        @admin.update_from_oauth(auth)
        sign_in_and_redirect @admin, event: :authentication
      else
        flash[:danger] = 'Account not found'
        redirect_to new_admin_session_url
      end
    end

    def failure
      redirect_to root_path
    end

    def google_oauth2
      sign_in_with 'Google'
    end
  end
end
