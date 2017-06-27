User.create(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'], confirmed_at: Time.now)
