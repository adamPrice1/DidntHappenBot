
#!/usr/bin/env ruby
require "Twitter"

$client = nil



$client = Twitter::REST::Client.new do |config|
  config.consumer_key        = 
  config.consumer_secret     =
  config.access_token        =
  config.access_token_secret =
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

end

getFollowers()
