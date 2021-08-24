# Viewing Party

[![Contributors][contributors-shield]][contributors-url]
[![Issues][issues-shield]][issues-url]
[![Stargazers][stars-shield]][stars-url]
[![Forks][forks-shield]][forks-url]

## Welcome to Viewing Party - A database-driven web application
<p align="center">
  <img src="https://user-images.githubusercontent.com/58891447/130533273-42be0ea9-4448-4f36-99d9-4026894d9853.png" alt="viewing_party_schema_v1"/>
</p>

Find the [project spec here](https://backend.turing.io/module3/projects/viewing_party)


## Table of Contents

- [Overview](#overview)
- [Tools Utilized](#tools-used)
- [Contributors](#contributors)


### Overview

Viewing party is an application in which users can explore movie options and create a viewing party event for the user and their invited friends during Mod 3 of 4 for Turing School's Back End Engineering Program.

#### Learning goals and areas of focus consisted of:

- Build a Rails application that requires basic authentication
- Consume JSON APIs that require authentication
- Implement a self-referential relationship in ActiveRecord
- Organize and refactor code to be more maintainable
- Apply RuboCop’s style guide for code quality
- Create instance and class methods on a Rails model that use ActiveRecord methods and helpers
- Write model and feature tests that fully cover data logic and potential user behavior

### <ins>Tools Used</ins>
- Ruby 2.7.2
- Rails 5.2.6
- PostgresQL
- Postico
- RSpec
- Pry
- Capybara
- Launchy
- Orderly
- SimpleCov
- Faraday
- Git/GitHub
- HTML
- CSS
- Bootstrap


### <ins>Contributors</ins>

👤  **Taylor Varoglu**
- Github: [Taylor Varoglu](https://github.com/tvaroglu)
- LinkedIn: [Taylor Varoglu](https://www.linkedin.com/in/taylorvaroglu/)

👤  **Dane Brophy**
- Github: [Dane Brophy](https://github.com/danembb)
- LinkedIn: [Dane Brophy](https://www.linkedin.com/in/dane-brophy/)


<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/tvaroglu/viewing_party.svg?style=flat-square
[contributors-url]: https://github.com/tvaroglu/viewing_party/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/tvaroglu/viewing_party.svg?style=flat-square
[forks-url]: https://github.com/tvaroglu/viewing_party/network/members
[stars-shield]: https://img.shields.io/github/stars/tvaroglu/viewing_party.svg?style=flat-square
[stars-url]: https://github.com/tvaroglu/viewing_party/stargazers
[issues-shield]: https://img.shields.io/github/issues/tvaroglu/viewing_party.svg?style=flat-square
[issues-url]: https://github.com/tvaroglu/viewing_party/issues


## Local Setup

1. Fork and Clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:create`

Example wireframes to follow are found [here](https://backend.turing.io/module3/projects/viewing_party/wireframes)


#### Project Configurations

* Ruby version
    ```bash
    $ ruby -v
    ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin20]
    ```

* [System dependencies](https://github.com/tvaroglu/viewing_party/blob/main/Gemfile)
    ```bash
    $ rails -v
    Rails 5.2.6
    ```

* Database creation
    ```bash
    $ rails db:{drop,create,migrate,seed}
    Created database 'viewing_party_development'
    Created database 'viewing_party_test'
    ```

* How to run the test suite
    ```bash
    $ bundle exec rspec -fd
    ```

* [Local Deployment](http://localhost:3000), for testing:
    ```bash
    $ rails s
    => Booting Puma
    => Rails 5.2.6 application starting in development
    => Run `rails server -h` for more startup options
    Puma starting in single mode...
    * Version 3.12.6 (ruby 2.7.2-p137), codename: Llamas in Pajamas
    * Min threads: 5, max threads: 5
    * Environment: development
    * Listening on tcp://localhost:3000
    Use Ctrl-C to stop
    ```

* [Heroku Deployment (link pending)](https://tvaroglu-little-esty-shop.herokuapp.com/), for production
