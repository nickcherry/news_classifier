// Enable ES6
require('babel-register');

// Enable colors for logging
require('colors');

// Imports
const mongo = require('mongodb').MongoClient;
const sentiment = require('sentiment');

// Constants
const MONGO_URI = 'mongodb://localhost:27017/news_classifier';

// Connect to Mongo
mongo.connect(MONGO_URI, (err, db) => {
  const collection = db.collection('articles');
  const sentiments = {};

  collection.count((err, count) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }

    const cursor = collection.find({});

    function analyzeArticle(err, article) {
      if (err) {
        console.error(err);
        process.exit(1);
      }
      if (article) {
        (sentiments[article.source] = sentiments[article.source] || []).push(
          sentiment(article.text)
        );
        cursor.nextObject(analyzeArticle);
      } else {
        Object.keys(sentiments).reduce((averages, source) => {
          const sum = sentiments[source].reduce((sum, sent) => sum + sent.score, 0);
          return averages.concat({
            source: source,
            score: sum / sentiments[source].length,
          });
        }, [])
        .sort((a, b) => b.score - a.score)
        .forEach((analysis) => {
          const color = analysis.score > 0 ? 'green' : 'red';
          console.log(`${ analysis.source.bold }: ${ analysis.score }`[color]);
        });
        process.exit();
      }
    }

    console.log("Analyzing articles...\n".cyan );
    cursor.nextObject(analyzeArticle);
  });
});
