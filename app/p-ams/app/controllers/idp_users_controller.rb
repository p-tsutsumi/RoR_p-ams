class IdpUsersController < ApplicationController
  def index
    @users = KeycloakAdminService.new.list_users
  end

  def new
    @user_form = IdpUserForm.new
  end

  def create
    @user_form = IdpUserForm.new(user_params)
    if @user_form.valid?
      service = KeycloakAdminService.new
      if service.create_user(user_params)
        redirect_to idp_users_path, notice: "ユーザ「#{@user_form.username}」を作成しました。"
      else
        flash.now[:alert] = "ユーザーの作成に失敗しました。"
        render :new, status: :unprocessable_content
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    service = KeycloakAdminService.new
    user = service.find_user(params[:id])
    username = user ? user["username"] : "不明なユーザ"
    if service.delete_user(params[:id], username)
      redirect_to idp_users_path, notice: "ユーザ「#{username}」を削除しました。", status: :see_other
    else
      redirect_to idp_users_path, alert: "ユーザの削除に失敗しました。", status: :see_other
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :first_name, :last_name)
    end
end
