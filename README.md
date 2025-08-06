# README

* Ruby version
  - please see `./.ruby-version`

* System dependencies
  - libvips42 for processing image in active storage

* Configuration
  - TBD

* Database creation
  ```bash
  ./bin/rails db:create
  ````

* Database initialization
  ```bash
  ./bin/rails db:migrate
  ````

* How to run the test suite
  ```bash
  # run test spec
  ./bin/rspec
  ./bin/rspec spec/features
  ./bin/rspec spec/features/auth_spec.rb

  # see test coverage (generated AFTER running test spec)
  open coverage/index.html
  ````

* Other development command
  ```bash
  # run development server
  ./bin/rails s

  # run rails console
  ./bin/rails c

  # two commands above are rails related command,
  # run command below to see the complete list
  ./bin/rails

  # run rubocop
  ./bin/rubocop
  ````

* Services (job queues, cache servers, search engines, etc.)
  - TBD

* Deployment instructions
  - TBD
