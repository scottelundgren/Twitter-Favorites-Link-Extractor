# Twitter Favorites Link Extractor

Now that Twitter uses the tweets your favorite to decide what other tweets to show you and mess up your timeline, 
favoriting tweets as a means to bookmark isn't useful. This very basic script will go through all your favorites, 
extract the links and dump them into a comma seperated values file then unfavorite the tweet. It will save favorites 
without links to a file too.

## Prerequisites 

1. Have Ruby installed
2. Sign into https://twitter.com/login 
3. Create an application at https://apps.twitter.com/

## Use

1. Copy the sample environment variables file to a new one: `cp sample.env .env`
2. Edit your `.env` file with the consumer key, consumer secret, access token and access secret from your Twitter app
3. Edit the `.env` file with an explicit path to filenames if you care
4. Run the script `ruby extract.rb`
