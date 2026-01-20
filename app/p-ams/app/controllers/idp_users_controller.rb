class IdpUsersController < ApplicationController
  def index
    @users = KeycloakAdminService.new.list_users
  end

  def new
  end
end
