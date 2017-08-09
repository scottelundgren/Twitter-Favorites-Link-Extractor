require 'twitter'
require 'dotenv'
require 'csv'

Dotenv.load

begin

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['CONSUMER_KEY']
    config.consumer_secret     = ENV['CONSUMER_SECRET']
    config.access_token        = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_SECRET']
  end

  # an index
  cur_page = 1
  # by default twitter retrieves the 20 most recent
  fav_page = 20
  max_page = client.user.favorites_count/fav_page

  while (cur_page < max_page)
    # fetch the favorites, loop through each tweet as f
    client.favorites(options = {page: "#{cur_page}", include_attrs: true}).each do |f|
      # for tweets with a link
      if f.urls.count > 0
        # open the file for appending because rate limits may require multiple passes
        CSV.open(ENV['FILE_LINKS'], "a") { |csv|
          # prevent multi line tweets, strip new line characters & double quote chars
          row = ["#{f.created_at}", "#{f.text}".gsub(/["\n]/,'')]
          # add each URL in a tweet
          f.urls.each { |u|
            row.push("#{u.attrs[:expanded_url]}")
          }
          csv << row
          puts row.to_csv
        }
        # unfavorite the tweet so the next fetch gets a new batch
        client.unfavorite(f.id)
      else
        # simple log of the tweets without links being unfavorited
        File.open(ENV['FILE_NOLINKS'], "a") { |nolinks|
          nolinks.puts "unfavoriting #{f.url}"
        }
        client.unfavorite(f.id)
      end
  end
  cur_page += 1
rescue Twitter::Error::TooManyRequests => error
  # from https://github.com/sferik/twitter/blob/master/examples/RateLimiting.md
  puts "Rate Limit Exceeded. Sleeping..."
  sleep error.rate_limit.reset_in + 1
  retry
end
