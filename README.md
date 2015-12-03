[![Build Status](https://travis-ci.org/mumuki/mumuki-junit-server.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-junit-server)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-junit-server/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-junit-server)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-junit-server/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-junit-server)

# Install the server

## Clone the project

```
git clone https://github.com/mumuki/mumuki-junit-server 
cd mumuki-junit-server
```

## Install JRuby

This project currently uses jruby instead of plain ruby. So install it first if you don't have it: 

```
rbenv install jruby-9.0.1.0
rbenv rehash
gem install bundler
```

## Install Dependencies

```
bundle install
```

# Run the server


```
RACK_ENV=development bundle exec rackup -p 4567
```



