class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    Rails.logger.debug "=== OmniAuth Raw Info ==="
    Rails.logger.debug auth.extra.raw_info.inspect

    is_admin = auth.extra.raw_info[:is_admin]
    user_id = auth.uid
    user_name = auth.info.name

    if is_admin
      session[:user_id] = user_id
      session[:user_name] = user_name

      Rails.logger.info("ログインしました: username=#{user_name}")
      redirect_to idp_users_path, notice: "管理者としてログインしました。"
    else
      redirect_to root_path, alert: "アクセス権がありません。 username=#{user_name}"
    end
  end

  def failure
    redirect_to root_path, alert: "認証に失敗しました。"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
