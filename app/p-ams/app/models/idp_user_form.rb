class IdpUserForm
  include ActiveModel::Model

  attr_accessor :id, :username, :email, :password, :password_confirmation, :first_name, :last_name, :enabled, :is_admin

  def initialize(attributes = {})
    super(attributes)
    @enabled = true if @enabled.nil?
  end

  validates :username, :email, :last_name, :first_name, :enabled, :is_admin, presence: true

  # 更新時にパスワードを変更しない場合は、空のパスワードが渡される。
  # パスワードの変更情報を受け取った場合は、バリデーションでパスワードの検証を行う。
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true, if: -> { password.present? }
  validates :password_confirmation, presence: true, if: -> { password.present? }
end
