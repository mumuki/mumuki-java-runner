[![Build Status](https://travis-ci.org/mumuki/mumuki-java-runner.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-java-runner)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-java-runner/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-java-runner)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-java-runner/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-java-runner)


# Install the server

## Clone the project

```
git clone https://github.com/mumuki/mumuki-junit-runner
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
./bin/pull_docker.sh
```

## Install Dependencies

```bash
bundle install
```

# Run the server

```bash
RACK_ENV=development bundle exec rackup -p 4567
```

# Test syntax

Tests are standard [JUnit 4](https://junit.org/junit4/) tests, with a few following considerations:

## Test class

You don't have to code the Test Class, but only the test methods instead. E.g.:

```java
@Test
public void testFoo() {
  Assert.assertEquals(Foo.bar(), 2);
}
```

## Imports

The following packages are imported by default:

* `java.util.*`
* `java.util.function.*`
* `java.util.stream.*`
* `java.util.stream.Collectors.*`
* `java.time.*`

## Test naming convention

There are no specific test naming conventions. However, using `snake_case` instead of `camelCase` is recommended, since underscores `_` will be converted into spaces in the test title. E.g.:

```java
@Test
// WARNING:This test title will be reported as "test something interesting"
// instead of just "test_something_interesting"
public void test_something_interesting() {
  Assert.assertEquals(Foo.bar(), 2);
}
```
