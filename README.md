##### Prerequisites

The setups steps expect following tools installed on the system.

- Ruby 3.0.0
- Rails 7.1.1
- Redis
##### 1. Check out the repository

```bash
git@github.com:Adi1169/AirPollution.git
```

##### 2. Run Bundle Install

```bash
bundle install
```


##### 2. Create database.yml file

Copy the sample database.yml file and edit the database configuration as required.

```bash
cp config/database.yml.sample config/database.yml
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:migrate
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

##### 5. Start the Sidekiq

You can start Sidekiq which is used for running background cron-jobs

```ruby
bundle exec sidekiq
```
##### 5. Run Tests

```ruby
bundle exec rspec spec
```
