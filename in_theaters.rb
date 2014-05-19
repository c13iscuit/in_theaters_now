require 'json'
require 'net/http'

if !ENV.has_key?("ROTTEN_TOMATOES_API_KEY")
  puts "You need to set the ROTTEN_TOMATOES_API_KEY environment variable."
  exit 1
end

api_key = ENV["ROTTEN_TOMATOES_API_KEY"]
uri = URI("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=#{api_key}")

response = Net::HTTP.get(uri)
movie_data = JSON.parse(response)

require 'json'
movie_data = JSON.parse(File.read('in_theaters.json'))
x = 0
movie_hash = {}
while x < movie_data["movies"].count
  names = []
  film = movie_data["movies"][x]
  avg_rating = (film["ratings"]["critics_score"] + film["ratings"]["audience_score"]) / 2
  film["abridged_cast"][0..2].each {|name|
  names << "#{name["name"]}" }
  movie_hash[avg_rating] = "#{film["title"]} (#{film["mpaa_rating"]})" + " #{names.join(", ")}"
  x += 1
end

movie_hash = (movie_hash.sort_by {|key, value| key}).reverse
movie_hash.each {|key, value| puts "#{key}" " - " "#{value}"}

