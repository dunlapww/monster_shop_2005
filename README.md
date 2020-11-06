## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for application models.

## Heroku

  https://mighty-tor-63819.herokuapp.com/

## Requirements

  - uses Ruby 2.5.3.
  - uses Rails 5.2.4.3
  - uses PostgreSQL

## Setup for Further Development

* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:create`
    * `rails db:migrate`
    * `rails db:seed`
* Run the test suite with `bundle exec rspec`. There should be 235 passing tests.
* Run your development server with `rails s`. Visit [localhost:3000/merchants](http://localhost:3000/merchants) to see the app in action.

## Schema Design

![image](https://user-images.githubusercontent.com/45305677/98310092-fd3f6f80-1f80-11eb-80aa-bc1fa9feddb8.png)

## Contributors

 * https://github.com/dunlapww
 * https://github.com/JesseMellinger
 * https://github.com/ETBassist
 * https://github.com/cpfergus1
