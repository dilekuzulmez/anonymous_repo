# FacebookService get user info from Facebook and returns hash of customer
# attributes
class FacebookService
  def initialize(provider, auth_code)
    @provider = provider
    @auth_code = auth_code
  end

  def execute
    send @provider
  end

  private

  def account_kit
    token_exchanger = Facebook::AccountKit::TokenExchanger.new(@auth_code)
    access_token = token_exchanger.fetch_access_token

    user = Facebook::AccountKit::UserAccount.new(access_token)
    info = user.fetch_user_info

    {
      phone_number: info['phone']['number'],
      uid: info['id'],
      provider: @provider
    }
  end

  def facebook
    graph = Koala::Facebook::API.new(@auth_code)
    info = graph.get_object('me', fields: %w[id email first_name last_name birthday])

    {
      uid: info['id'],
      birthday: info['birthday'],
      first_name: info['first_name'],
      last_name: info['last_name'],
      provider: @provider
    }
  end
end
