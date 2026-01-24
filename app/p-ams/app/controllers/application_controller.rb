class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :current_user, :logged_in?

  private
    def current_user
      @current_user ||= session[:user_name] if logged_in?
    end
    def authenticate_user!
      unless logged_in?
        Rails.logger.error("ログインしていません。")
        redirect_to root_path
      end
    end

    def logged_in?
      session[:user_id].present?
    end

    def ensure_admin!
      unless session[:is_admin] == true
        Rails.logger.error("管理者ではありません。")
        redirect_to root_path
      end
    end

    def validate_token_with_keycloak
      return false if session[:access_token].blank?

      token = session[:access_token]
      response = introspect_token(token)

      result = response
      is_active = result["active"] == true
      is_admin_now = result["is_admin"] == true
      is_active && is_admin_now

    rescue => e
      Rails.logger.error "Keycloak Connection Error: #{e.message}"
      false
    end

    def introspect_token(token)
      conn = Faraday.new(url: "https://localhost") do |f|
        f.request  :url_encoded             # フォームデータ送信
        f.response :json                    # レスポンスを自動でJSONパース
        f.options.timeout = 2               # 2秒でタイムアウト
        f.options.open_timeout = 2
      end

      response = conn.post("/auth/realms/#{ENV.fetch('KC_REALM')}/protocol/openid-connect/token/introspect", {
        token: session[:access_token],
        client_id: ENV.fetch("KC_CLIENT_ID"),
        client_secret: ENV.fetch("KC_CLIENT_SECRET")
      })
      response.body
    end

    def refresh_access_token(token)
      conn = Faraday.new(url: "https://localhost") { |f| f.request :url_encoded; f.response :json }
      response = conn.post("/auth/realms/#{ENV.fetch('KC_REALM')}/protocol/openid-connect/token", {
        grant_type: "refresh_token",
        refresh_token: session[:refresh_token],
        client_id: ENV.fetch("KC_CLIENT_ID"),
        client_secret: ENV.fetch("KC_CLIENT_SECRET")
      })

      if response.success?
        session[:access_token] = response.body["access_token"]
        session[:refresh_token] = response.body["refresh_token"] if response.body["refresh_token"]

        introspect_token(session[:access_token])
      else
        Rails.logger.warn "Refresh Token failed: #{response.body}"
        { "active" => false }
      end
    end


    def verify_keycloak_session!
      unless validate_token_with_keycloak
        id_token = session[:id_token]
        session.clear

        keycloak_logout(id_token)
      end
    end
    def keycloak_logout(id_token)
      session.clear
      issuer = "https://localhost/auth/realms/#{ENV.fetch("KC_REALM")}"
      post_logout_redirect_uri = ERB::Util.url_encode("http://localhost:3000/login")

      logout_url = "#{issuer}/protocol/openid-connect/logout?id_token_hint=#{id_token}&post_logout_redirect_uri=#{post_logout_redirect_uri}"
      redirect_to logout_url, allow_other_host: true
    end
end
