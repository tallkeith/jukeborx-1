require "sinatra/base"
require "active_record"
require "mp3info"
require "yaml"
require "json"
require "pry"

require "jukeborx/version"
require "jukeborx/song"

db_config = YAML.load(File.open("config/database.yml"))
ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Base.logger = Logger.new(STDOUT)

MUSIC_DIR = "/Users/brit/Music/downloads"

def import(dir)
  files = Dir.glob(File.join(dir, '*.mp3'))
  files.each do |mp3_file|
    begin
      tag = Mp3Info.open(mp3_file) { |mp3| mp3.tag }
      Jukeborx::Song.create(artist: tag.artist,
                            album: tag.album,
                            title: tag.title,
                            year: tag.year,
                            filename: mp3_file)
    rescue Mp3InfoError => e
      puts "#{mp3_file} failed with: #{e.message}"
    rescue Encoding::InvalidByteSequenceError => e
      puts "Blew up trying to read: #{mp3_file}"
    end
  end
end

binding.pry

module Jukeborx
  class Api < Sinatra::Application

    get "/api/artists" do
      content_type :json
      artists = Song.select(:artist).distinct.map {|x| x.artist }.compact
      artists.to_json
    end

    get "/api/albums" do
      content_type :json
      albums = Song.select(:albums).distinct.map { |x| x.album }.compact
      albums.to_json
    end

    get "/api/artists/:search" do
      search = params["search"]
      content_type :json
      results = Song.where("artist LIKE '%#{search}%'")
      # status 404 if results.size.zero?
      results.to_json
    end

    post "/api/play/:id/:user_id" do
      id = params["id"].to_i
      user_id = params["user_id"].to_i
      song = Song.find(id)

    # HW question 2
      

      content_type :json
      if song
        song.play
        { message: "Now playing '#{song.title}'" }.to_json
      else
        status 404
        { message: "Couldn't find song with ID: '#{id}'" }.to_json
      end
    end

    delete "/api/stop" do
      spawn("killall afplay")
      content_type :json
      { message: "You ruined the party." }.to_json
    end

    ### Web/HTML routes below

    get "/" do
      erb :index, locals: { library: Song.all }
    end

    ## localhost:4567/search?cat=artists&q=mingus
    get "/search" do
      query = params["q"]
      search_type = params["cat"]
      if query && search_type == "artists"
        results = Song.where("artist LIKE '%#{query}%'")
      elsif query && search_type == "albums"
        results = Song.where("album LIKE '%#{query}%'")
      elsif query && search_type == "titles"
        results = Song.where("title LIKE '%#{query}%'")
      else
        results = []
        status 404
      end
      erb :search, locals: { results: results, q: query, type: search_type }
    end

    post "/play" do
      song_id = params["id"]
      if song_id
        song = Song.find(song_id)
        song.play if song
        redirect to("/")
      else
        status 404
        "You fucked up. Where's my ID?"
      end
    end

    run! if app_file == $0
  end
end
