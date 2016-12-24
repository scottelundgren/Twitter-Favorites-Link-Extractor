require 'rubygems'
require 'oauth'
require 'json'
require 'dotenv'

Dotenv.load

consumer_key = OAuth::Consumer.new(
    ENV['CONSUMER_KEY'],
    ENV['CONSUMER_SECRET'])
access_token = OAuth::Token.new(
    ENV['ACCESS_TOKEN'],
    ENV['ACCESS_SECRET'])

# Note that the type of request has changed to POST.
# The request parameters have also moved to the body
# of the request instead of being put in the URL.
baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/update.json"
address = URI("#{baseurl}#{path}")
request = Net::HTTP::Post.new address.request_uri
request.set_form_data(
    "status" => "",
)

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# Issue the request.
request.oauth! http, consumer_key, access_token
http.start
response = http.request request

# Parse and print the Tweet if the response code was 200
tweet = nil
if response.code == '200' then
  tweet = JSON.parse(response.body)
  puts "Successfully sent #{tweet["text"]}"
else
  puts "Could not send the Tweet! " +
           "Code:#{response.code} Body:#{response.body}"
end