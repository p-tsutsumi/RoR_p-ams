class HomeController < ApplicationController
  # ここでログイン画面自体を見れるようにスキップ設定が必要
  # skip_before_action :authenticate_user!, raise: false

  def index
    # TODO: ログイン済みのユーザはログイン画面をスキップ
  end
end
