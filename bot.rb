
#!/usr/bin/env ruby
require "Twitter"
load'Keys.rb'

$client = nil
$tweetCount = 0

$client = Twitter::REST::Client.new do |config|
  config.consumer_key        = $keys["TWITTER_KEY"]
  config.consumer_secret     = $keys["TWITTER_SECRET"]
  config.access_token        = $keys["TWITTER_TOKEN"]
  config.access_token_secret = $keys["TWITTER_TOKEN_SECRET"]
end

def getFollowers()
  followers = []
  $client.followers("BottyMcBotFaced").attrs[:users].each do |user|

    getDidntHappenTweets(user[:screen_name].to_s)

  end

end

def getDidntHappenTweets(handle)

  $client.search("to:" + handle + " \"didn't happen\"").attrs[:statuses].each do |tweet|

    respondToTweet(tweet[:id])

  end

end

def respondToTweet(id) #1044932227790974976

  responses = [
    "Congrats on your original tweet! Here's a medal to mark your achievement: \u{1F4A9} ", #poop emoji
    "",
    ""
  ]

  $client.update(responses[0],  in_reply_to_status_id: id)
  puts "sent tweet"
  $tweetCount += 1

end

getFollowers()
puts "Sent " + $tweetcount.to_s + " tweets"
