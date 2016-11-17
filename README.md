Ruby on Rails Form App
```
ruby '2.3.0'
```
Rails 5.0.0.1
```
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
```

#### Server
Use Rails 5 default server, Puma to run highly concurrent HTTP 1.1 server for Ruby/Rack applications
```
gem 'puma'
```

#### Account System
Use Devise as authentication database
```
gem 'devise'
```
CanCan is an authorization library for Ruby on Rails
```
gem 'cancancan'
```

#### Simple Form
Add it to your Gemfile:
```
gem 'simple_form'
```
Run the following command to install it:
```
bundle install
```
Run the generator for SimpleForm Bootstrap integration:
```
rails generate simple_form:install --bootstrap
```
This gem can help you work with Enum feather, I18n and simple_form
```
gem 'enum_help'
```

#### Database
Use Postgresql as the database for Active Record
```
gem 'pg', '~> 0.18.4'
```

Setup favicon icons
```
group :development do
  gem 'rails_real_favicon'
end
```
dotenv is initialized in your Rails app during the before_configuration callback, create a .env file in the root directory of your project.
```
gem 'dotenv-rails', groups: [:development, :test]
```
