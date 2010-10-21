namespace :devise do

  desc 'setup Devise example migrating db and creating a default customer'
  task :setup => ['db:drop', 'db:create', 'db:migrate', 'db:fixtures:load', 'environment'] do
    user = Customer.create! do |u|
      u.first_name = 'Devise'
      u.last_name  = 'Customer'
      u.email      = 'devise@customer.com'
      u.password   = '123456'
      u.password_confirmation = '123456'
    end
    user.confirm!
    puts 'New Devise Customer created!'
    puts 'E-mail  : ' << user.email
    puts 'Password: ' << user.password
    puts

    publisher = Publisher.create! do |u|
      u.first_name = 'Devise'
      u.last_name  = 'Publisher'
      u.email      = 'devise@publisher.com'
      u.password   = '123456'
      u.password_confirmation = '123456'
    end
    publisher.confirm!
    puts 'New Devise Publisher created!'
    puts 'E-mail  : ' << publisher.email
    puts 'Password: ' << publisher.password
    puts

    admin = Admin.create! do |u|
      u.email      = 'devise@admin.com'
      u.password   = '123456'
      u.password_confirmation = '123456'
    end
    puts 'New Devise Admin created!'
    puts 'E-mail  : ' << admin.email
    puts 'Password: ' << admin.password
  end
end

