[![Build Status](https://travis-ci.org/mumuki/mumuki-java-server.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-java-server)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-java-server/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-java-server)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-java-server/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-java-server)

# Install the server

## Clone the project

```
git clone https://github.com/mumuki/mumuki-junit-server 
cd mumuki-junit-server
```

## Install Ruby

```bash
rbenv install 2.0.0-p481
rbenv rehash
gem install bundler
```

## Install docker image

This runner is dockerized, so you will need to install Docker first. Then: 

```bash
docker pull mumuki/mumuki-junit-worker
```

## Install Dependencies

```bash
bundle install
```

# Run the server

```bash
RACK_ENV=development bundle exec rackup -p 4567
```



