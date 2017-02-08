# News Classifier

Simple machine learning and analysis applied to news.

## Installing Dependencies

After installing [Homebrew](http://brew.sh/), download and install [Mongo](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/) and [GSL](http://brewformulas.org/Gsl) by running the following from the project root:

```shell
brew install mongodb
brew install gsl # improves classification performance
```

Ensure that Mongo is running with:

```shell
brew services start mongodb
```

After installing [Ruby](https://www.ruby-lang.org/en/) and [Bundler](http://bundler.io/), run the following from the project's root to install necessary gem dependencies:

```shell
bundle install
```

After installing [Node](https://nodejs.org/en/) and [NPM](https://www.npmjs.com/), run the following from the project's root:

```shell
npm install

## Crawling News Sources

To crawl news sources and save their content to the `articles` collection of the `news_classifier` database, run the following from the project root:

```shell
ruby scripts/crawl.rb
```

To drop the `articles` collection before crawling, add the `--drop-collection` option:

```shell
ruby scripts/crawl.rb --drop-collection
```

## Classifying Content

Once the news sources have been crawled, run the following command to launch the interactive classifier:

```shell
ruby scripts/classify.rb
```

## Finding Related Content

Once the news sources have been crawled, run the following command to find content related to provided strings:

```shell
ruby scripts/find_related.rb
```

## Sentiment Analysis

Onde the news sources have been crawled, run the following command to calculate the average sentiment for each source.

```shell
node scripts/sentiment.js
```
