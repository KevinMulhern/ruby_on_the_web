require 'json'

response = <<END_OF_STRING
this is my long ass\r\njust to see
string, I am trying to figure
out what '\\r' does.


END_OF_STRING

print response.to_json

puts response.methods