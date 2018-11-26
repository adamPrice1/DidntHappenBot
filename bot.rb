
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
  begin
    $client.followers("BottyMcBotFaced").attrs[:users].each do |user|

      getDidntHappenTweets(user[:screen_name].to_s)

    end
  rescue Twitter::Error::TooManyRequests => error
    sleep error.rate_limit.reset_in + 1
    retry
  end

end

def getDidntHappenTweets(handle)

    begin
      $client.search("to:" + handle , result_type: "recent" , count:100 ).attrs[:statuses].each do |tweet|

        if isDidntHappenTweet(tweet[:id]) && probablyNotRespondedToo(tweet[:id])

          respondToTweet(tweet[:id])

        end

      end
    rescue Twitter::Error::TooManyRequests => error
      sleep error.rate_limit.reset_in + 1
      retry
    end
end



def respondToTweet(id) #1044932227790974976

  responses = [
    "Congrats on your original tweet! Here's a medal to mark your achievement: \u{1F4A9} ", #poop emoji
    "Didn't happen nonce.",
    "Haha you're so funny man, #madbanter #lads #stella",
  ]

  begin
    $client.update(responses[rand(0..(responses.length-1))],  in_reply_to_status_id: id)
  rescue Twitter::Error::TooManyRequests => error
    sleep error.rate_limit.reset_in + 1
    retry
  end
  $tweetCount += 1
  puts "sent tweet " + $tweetCount.to_s + " With ID: "+ id.to_s

end

def isDidntHappenTweet(id)

  begin
    tweet = $client.status(id)
  rescue Twitter::Error::TooManyRequests => error
    sleep error.rate_limit.reset_in + 1
    retry
  end

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
  begin
    $client.user_timeline("BottyMcBotFaced", count: 200).each do |tweet|

      if tweet.attrs[:in_reply_to_status_id] == id
        return false
      end
    end
  rescue Twitter::Error::TooManyRequests => error
    sleep error.rate_limit.reset_in + 1
    retry
  end

  return true

end

getFollowers()
