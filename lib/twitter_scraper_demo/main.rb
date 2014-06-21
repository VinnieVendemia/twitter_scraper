require 'yaml'


Capybara.register_driver :firefox_ubuntu do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile["network.http.use-cache"] = false
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 180
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => client)
end


module Scraper


  module TwitterScraper

    class Robot

      attr_accessor :session

      def initialize
        @session = get_session
      end

      def get_session
        Capybara::Session.new(:firefox_ubuntu)
      end

      def s
      	@session
      end

      def goto_twitter
      	s.visit "http://twitter.com"
      end

      def login
      	data = get_username_password
      	s.fill_in "signin-email", :with => data["username"]
      	s.fill_in "signin-password", :with => data["password"]
      	s.click_button "Sign in"
      end 

      def get_username_password
      	data = YAML.load_file "/Users/Vinnie/twitter.yml"
      end

      def make_post
      	s.find(:xpath, "//div[@id='tweet-box-mini-home-profile']").click
      	s.fill_in "tweet-box-mini-home-profile", :with => "At the Jibe Hackaton!"
      	s.find(:xpath, "//button[@class='btn primary-btn tweet-action tweet-btn js-tweet-btn disabled']").click
      end 

      def get_tweets
      	s.all(:css, "li[id^='stream-item-tweet']")
      end 

      def get_twitter_handle(tweet)
      	tweet.find(:css, "strong[class='fullname js-action-profile-name show-popup-with-id']").text
      end 

      def get_tweet_text(tweet)
      	tweet.find(:css, "p[class='js-tweet-text tweet-text']").text
      end

      def get_tweets_array
      	goto_twitter
      	login
      	tweets = get_tweets
      	arr = []
      	tweets.each do |t|
      		arr << {
      			:handle => get_twitter_handle(t) ,
      			:tweet => get_tweet_text(t)
      		}
      	end

      	return arr 
      end 
    
    end



  end

end
