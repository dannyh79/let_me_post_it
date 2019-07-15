# session cookies expires after 30 minutes
Rails.application.config.session_store :cookie_store, expire_after: 30.minutes