require "sinatra"
require "mp3info"
require "pry"

require "jukeborx/version"
require "jukeborx/song"
require "jukeborx/library"

module Jukeborx
end

class Student
end

get '/hi' do
  Student.new.to_s
end


get "/add-one" do
  @count ||= 0
  @count += 1
  "\n\n The count is #{@count}! \n\n"
end

get "/repos/:org/:repo/issues" do
  # binding.pry
  "that's a lotta issues"
end

get "/hello/:name" do
  # binding.pry
  pretty_name = params["name"].capitalize
  "Hello there, #{pretty_name}!"
end

post '/hi' do
  binding.pry
  "I created a thing"
end
