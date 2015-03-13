require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
	attr_reader :client

	def initialize
		Bitly.use_api_version_3
		@bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		puts "Initializing..."
		@client = JumpstartAuth.twitter
	end

	def run
		puts "Welcome to the jsl Twitter client"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split()
			command = parts[0]

			case command
			when "q" then puts "Goodbye!"
			when "t" then tweet(parts[1..-1].join(" "))
			when "dm" then dm(parts[1], parts[2..-1].join(" "))
			when "spam" then spam_my_followers(parts[1..-1].join(" "))
			when 'elt' then everyones_last_tweet
			when "s" then shorten(parts[1])
			when "turl" then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
			else
				puts "Sorry, I dont know how to #{command}"
			end
		end
	end

	def tweet(message)
		if message.size <= 140
			@client.update(message)
		else
			puts "The message was over 140 characters, did not tweet"
		end
	end

	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message
		message = "d @#{target} #{message}"
		
		screen_names = @client.followers.collect {|follower| @client.user(follower).screen_name}
		puts screen_names
		if screen_names.include?(target)
			tweet(message)
		else
			puts "You can only Direct message people who follow you!"
		end
	end

	def followers_list
		screen_names = []
		@client.followers.each do |f|
			screen_names << @client.user(f).screen_name
		end
		return screen_names
	end

	def spam_my_followers(message)
		followers = followers_list

		followers.each do |f|
			dm(f, message)
		end
	end

	def everyones_last_tweet
		friends = @client.followers.collect {|follower| @client.user(follower)}
		friends = friends.sort_by{|f| f.screen_name.downcase}
		puts friends
		puts "This is the tweets message before it goes into the loop"
		friends.each do |friend|
			puts "In the loop"
			last_message = friend.status.created_at

			puts "#{friend.screen_name} said this on #{last_message.strftime("%A, %b %d")}..."
			puts friend.status.text
			puts " "
		end
	end

	def shorten(original_url)
		puts "Shortening this URL: #{original_url}"
		return @bitly.shorten(original_url).short_url
	end
end

blogger = MicroBlogger.new

string = "".ljust(145, "abcd")
blogger.run


