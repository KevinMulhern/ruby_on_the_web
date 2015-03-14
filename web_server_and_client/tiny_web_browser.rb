require 'socket'
require 'json'

host = 'localhost'
port = 2000
path = "./index.html" 
user_agent = "SimpleBrowser/1.0"

def post_this
	puts "What is your name: "
	name = gets.chomp
	puts "What is your email address?: "
	email = gets.chomp

	hash_send = {:viking => {:name => name, :email => email}}
	data = hash_send.to_json
	puts data
	return data
end

def get_method(path)
valid = false
input = ''
	while valid == false
		print "please enter either GET or POST: "
		input = gets.chomp.upcase

		if input == "GET"
			puts "In the get"
			request = "GET #{path} HTTP/1.0\r\n\r\n"
			valid = true
		elsif input == "POST"
			post_data = post_this
	 		request = "#{input} ./thanks.html HTTP/1.0\nContent-Type: JSON\nContent-length: #{post_data.size}\r\n\r\n#{post_data}"
	 		valid = true
	 	else
	 		puts "Invalid command, please enter again"
	 	end
	 end
	 return request
end

request = get_method(path)

socket = TCPSocket.open(host,port)
socket.print(request)
response = socket.read

headers,body = response.split("\r\n\r\n", 2)
print body
socket.close

