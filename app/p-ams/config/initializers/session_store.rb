Rails.application.config.session_store :redis_session_store,
  serializer: :json,
  redis: {
    expire_after: 1.day,
    key_prefix: "p-ams:session:",
    url: "redis://redis:6379/0" # Dockerサービス名を使用
  }
