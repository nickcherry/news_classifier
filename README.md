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

To crawl news sources and save their content to the `articles` collection of the `news_classifier` database, run the following from the project root:

```shell
ruby exe/crawl.rb
```

To drop the `articles` collection before crawling, run add the `--drop-collection` option:

```shell
ruby exe/crawl.rb --drop-collection
```

## Classifying News Sources

Once the news sources have been crawled, run the following command to launch the interactive classifier:

```shell
ruby exe/classify.rb
```
