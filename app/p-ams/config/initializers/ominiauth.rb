
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid_connect, {
    name: :keycloak,
    scope: [:openid, :email, :profile],
    response_type: :code,
    discovery: true,
    issuer:  "https://localhost/auth/realms/#{ENV.fetch("KC_REALM")}",
    client_options: {
      identifier: ENV.fetch("KC_CLIENT_ID"),
      secret: ENV.fetch("KC_CLIENT_SECRET"),
      redirect_uri: ENV.fetch("KC_REDIRECT_URI"),
      # connection_opts: {
      #  ssl: { verify: false } # ここでSSL検証を無効化
      # }
    }
  }
end
