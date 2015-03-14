require 'socket'
require 'json'



server = TCPServer.open(2000)
loop {
	header_lines = ""
	client = server.accept
	
	while line = client.gets
		header_lines += line
		break if header_lines =~ /\r\n\r\n$/
	end


	header = header_lines.split("\n")
	request = header[0].split(" ")

	method = request[0]
	path = request[1]
	http = request[2]

	puts method
	puts http
	puts path



	if File.exist?(path)
		puts "file exists"
		content_body = File.read(path)
		
		if method == "GET"
			client.puts("#{http} 200 ok\nContent-Type: html\ncontent-size: #{content_body.size}\r\n\r\n#{content_body}")
		elsif method == "POST"
			bodySize = header[-2].split(" ")[1].to_i
			body = client.read(bodySize)
			params = JSON.parse(body)
			puts params
			puts params.keys
			data = "<li>Name: #{params['viking']['name']}</li><li>Email: #{params['viking']['email']}</li>"
			puts data
			content_body = content_body.gsub("<%= yield %>", data)
			client.puts("#{http} 200 ok\nContent-Type: html\ncontent-size: #{content_body.size}\r\n\r\n#{content_body}")
		end
			
	else
		client.puts("#{http} 404 Not Found\r\n\r\n")
	end

	client.close
}