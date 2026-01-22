
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

    conn = Faraday.new(ssl: { verify: true })
    response = conn.get("#{@base_url}/admin/realms/#{@realm}/users") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
      req.headers["Content-Type"] = "application/json"
    end

    JSON.parse(response.body)
  end

  def find_user(user_id)
    token = get_access_token

    conn = Faraday.new(ssl: { verify: true })
    response = conn.get("#{@base_url}/admin/realms/#{@realm}/users/#{user_id}") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
    end
    return nil unless response.success?

    JSON.parse(response.body)
  rescue => e
    Rails.logger.error "Keycloak ユーザ取得エラー: #{e.message}"
    nil
  end

  def create_user(user_params)
    token = get_access_token

    conn = Faraday.new(ssl: { verify: true })
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

  def delete_user(user_id, username)
    token = get_access_token

    conn = Faraday.new(ssl: { verify: true })
    response = conn.delete("#{@base_url}/admin/realms/#{@realm}/users/#{user_id}") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
    end

    if response.success? || response.status == 404
      Rails.logger.info "Keycloak ユーザ削除成功: ID=#{user_id}, username=#{username} (Status=#{response.status})"
      true
    else
      Rails.logger.warn "Keycloak ユーザ削除失敗: ID=#{user_id}, username=#{username} (Status=#{response.status}, Body=#{response.body})"
      false
    end

  rescue => e
    Rails.logger.error "Keycloak ユーザ削除エラー ID=#{user_id}, username=#{username} #{e.message}"
    false
  end
end
