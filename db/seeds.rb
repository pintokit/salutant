puts "Seeding admin users..."

User.create(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PW'], confirmed_at: Time.now)

User.create(email: ENV['ADMIN_2_EMAIL'], password: ENV['ADMIN_2_PW'], confirmed_at: Time.now)
