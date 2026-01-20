
class KeycloakAdminService
  def initialize
    @base_url = ENV.fetch("KEYCLOAK_URL")
    @realm = ENV.fetch("KC_REALM")
    @admin_user = ENV.fetch("KC_ADMIN_USER")
    @admin_password = ENV.fetch("KC_ADMIN_PASSWORD")
  end

  def get_access_token
    conn = Faraday.new(ssl: { verify: true })
    response = conn.post("#{@base_url}/realms/master/protocol/openid-connect/token") do |req|
      req.headers["Content-Type"] = "application/x-www-form-urlencoded"
      req.body = {
        username: @admin_user,
        password: @admin_password,
        grant_type: "password",
        client_id: "admin-cli"
      }
    end
    JSON.parse(response.body)["access_token"]
  end

  def list_users
    token = get_access_token

    conn = Faraday.new()
    response = conn.get("#{@base_url}/admin/realms/#{@realm}/users") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
      req.headers["Content-Type"] = "application/json"
    end

    JSON.parse(response.body)
  end

  def create_user(user_params)
    token = get_access_token

    conn = Faraday.new()
    response = conn.post("#{@base_url}/admin/realms/#{@realm}/users") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
      req.headers["Content-Type"] = "application/json"
      req.body = {
        username: user_params[:username],
        enabled: true,
        email: user_params[:email],
        firstName: user_params[:first_name],
        lastName: user_params[:last_name],
        credentials: [{
          type: "password",
          value: user_params[:password],
          temporary: false # 初回ログイン時のパスワード変更を強制しない
        }]
      }.to_json
    end

    response.success?
  end
end
