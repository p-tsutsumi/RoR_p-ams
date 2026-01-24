class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    auth = request.env["omniauth.auth"]

    Rails.logger.debug "=== OmniAuth Raw Info ==="
    Rails.logger.debug auth.extra.raw_info.inspect
    raw_info = auth.extra.raw_info
    puts "DEBUG: is_admin value is #{raw_info[:is_admin].inspect} (Class: #{raw_info[:is_admin].class})"

    is_admin = auth.extra.raw_info[:is_admin]
    user_id = auth.uid
    user_name = auth.info.name

    if is_admin
      session[:refresh_token] = auth.credentials.refresh_token
      session[:id_token] = auth.credentials.id_token
      session[:access_token] = auth.credentials.token
      session[:user_id] = user_id
      session[:user_name] = user_name
      session[:is_admin] = is_admin

      Rails.logger.info("ログインしました: username=#{user_name}")
      redirect_to idp_users_path, notice: "管理者としてログインしました。"
    else
      keycloak_logout(auth.credentials.id_token)
    end
  end

  def failure
    redirect_to root_path, alert: "認証に失敗しました。"
  end

  def destroy
    id_token = session[:id_token]
    keycloak_logout(id_token)
  end

  private
    def keycloak_logout(id_token)
      session.clear
      issuer = "https://localhost/auth/realms/#{ENV.fetch("KC_REALM")}"
      post_logout_redirect_uri = ERB::Util.url_encode("http://localhost:3000/login")

      logout_url = "#{issuer}/protocol/openid-connect/logout?id_token_hint=#{id_token}&post_logout_redirect_uri=#{post_logout_redirect_uri}"
      redirect_to logout_url, allow_other_host: true
    end
end
