namespace :devise do

  desc 'setup Devise example migrating db and creating a default customer'
  task :setup => ['db:drop', 'db:create', 'db:migrate', 'db:fixtures:load', 'environment'] do
    user = Customer.create! do |u|
      u.first_name = 'Devise'
      u.last_name  = 'Customer'
      u.email      = 'devise@customer.com'
      u.address1   = 'where the streets have no name'
      u.city       = 'Outskirtsville'
      u.state      = 'UT'
      u.country    = 'US'
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
    
    wholesaler = Wholesaler.create! do |u|
      u.name       = "Wholesale Account"
      u.email      = 'devise@wholesaler.com'
      u.password   = '123456'
      u.password_confirmation = '123456'
    end
    puts 'New Devise Wholesaler created!'
    puts 'E-mail  : ' << wholesaler.email
    puts 'Password: ' << wholesaler.password
    
    affiliate = Affiliate.create! do |u|
      u.name       = "Affiliate Account"
      u.email      = 'devise@affiliate.com'
      u.password   = '123456'
      u.password_confirmation = '123456'
    end
    puts 'New Devise Wholesaler created!'
    puts 'E-mail  : ' << affiliate.email
    puts 'Password: ' << affiliate.password

    # "John" publisher used to check Sales report, so confirm to allow login
    p = Publisher.find(:first, :conditions => {:email => 'john@foo.bar'})
    p.confirm!
  end
end

