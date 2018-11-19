
#!/usr/bin/env ruby
require "Twitter"
require "dhash"
require "open-uri"
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

   return $client.search("to:" + handle , result_type: "recent" , count:100 ).attrs[:statuses].each do |tweet|

     if isDidntHappenTweet(tweet[:id]) && probablyNotRespondedToo(tweet[:id])

      respondToTweet(tweet[:id])

    end

  end

end



def respondToTweet(id) #1044932227790974976

  responses = [
    "Congrats on your original tweet! Here's a medal to mark your achievement: \u{1F4A9} ", #poop emoji
    "Didn't happen nonce.",
    "You're so original that a computer can recognise your tweets",
    "Haha you're so funny man, #madbanter #lads #stella",
  ]

  $client.update(responses[0],  in_reply_to_status_id: id)
  $tweetCount += 1
  puts "sent tweet " + $tweetCount.to_s + " With ID: "+ id.to_s

end

def isDidntHappenTweet(id)

  tweet = $client.status(id)

  tweet.media.each do |media|

    begin
      File.open('temp.jpg', 'wb') do |fo|
        fo.write open(media.attrs[:media_url]).read
      end
    rescue
      puts "unable to get image  " + media.attrs[:media_url]
      return false
    end
    hash1 = Dhash.calculate('temp.jpg')
    images = Dir.glob("samples/*.jpg")

    images.each do |image|
      hash2 = Dhash.calculate(image)
      if Dhash.hamming(hash1, hash2) < 10
        return true
      end
    end
  end
  return false
end

def probablyNotRespondedToo(id)

  $client.user_timeline("BottyMcBotFaced", count: 200).each do |tweet|

    if tweet.attrs[:in_reply_to_status_id] == id
      return false
    end
  end

  return true

end

getFollowers()
