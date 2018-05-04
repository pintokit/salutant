# Salutant
### Process form submissions from static sites.

## Prerequisites

This project requires:

* Ruby 2.5.1, preferably managed using [RVM](http://rvm.io)
* PostgreSQL must be installed and accepting connections
* [Redis](http://redis.io) must be installed and running on localhost with the default port

On a Mac, you can obtain all of the above packages using [Homebrew](http://brew.sh).

If you need help setting up a Ruby development environment, check out this [Rails OS X Setup Guide](https://mattbrictson.com/rails-osx-setup-guide).

## Getting started

### Setup App

Run the `bin/setup` script. This script will:
* Check you have the required Ruby version
* Install gems using Bundler
* Create a local copy of `.env`
* Create and migrate the database

### Setup Variables
- Create account with [Skylight](https://www.skylight.io), to get free analytics
- Use default mailer with a personal Email address
- Last required variable is production app domain

### Run it!

1. Run `bundle exec rspec` to make sure everything works.
2. Run `rails s` to start the Rails app.
