
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
    responce = conn.get("#{@base_url}/admin/realms/#{@realm}/users") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
      req.headers["Content-Type"] = "application/json"
    end

    JSON.parse(responce.body)
  end
end
