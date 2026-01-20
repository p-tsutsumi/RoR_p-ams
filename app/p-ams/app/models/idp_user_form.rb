class IdpUserForm
  include ActiveModel::Model

  attr_accessor :username, :email, :password, :password_confirmation, :first_name, :last_name

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true

  validates :password_confirmation, presence: true
end
