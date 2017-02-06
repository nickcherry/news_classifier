# News Classifier

## Installing Dependencies

After installing [Homebrew](http://brew.sh/), download and install [Mongo](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/) and [GSL](http://brewformulas.org/Gsl) by running the following from the project root:

```shell
brew install mongodb
brew install gsl
```

Ensure that Mongo is running with:

```shell
brew services start mongodb
```

After installing [Ruby](https://www.ruby-lang.org/en/) and [Bundler](http://bundler.io/), run the following from the project's root to install necessary gem dependencies:

```shell
bundle install
```

## Crawling News Sources

To crawl news sources, run the following from the project root:

```shell
ruby exe/crawl
```
