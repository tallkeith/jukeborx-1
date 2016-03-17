require "sinatra/base"
require "mp3info"
require "json"
require "pry"

require "jukeborx/version"
require "jukeborx/song"
require "jukeborx/library"

MUSIC_DIR = "/Users/brit/Music/downloads"
LIBRARY = Jukeborx::Library.new(MUSIC_DIR)

module Jukeborx
  class Api < Sinatra::Application

    get "/api/artists" do
      content_type :json
      LIBRARY.list_artists.to_json
    end

    get "/api/albums" do
      content_type :json
      LIBRARY.list_albums.to_json
    end

    get "/api/artists/:search" do
      search = params["search"]
      content_type :json
      results = LIBRARY.match_artists(search)
      # status 404 if results.size.zero?
      results.to_json
    end

    post "/api/play/:id" do
      id = params["id"].to_i
      song = LIBRARY.get_song(id)
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
      erb :index, locals: { library: LIBRARY.songs }
    end

    ## localhost:4567/search?cat=artists&q=mingus
    get "/search" do
      query = params["q"]
      search_type = params["cat"]
      if query && search_type == "artists"
        results = LIBRARY.match_artists(query)
      elsif query && search_type == "albums"
        results = LIBRARY.match_albums(query)
      elsif query && search_type == "titles"
        results = LIBRARY.match_titles(query)
      else
        results = []
        status 404
      end
      erb :search, locals: { results: results, q: query, type: search_type }
    end

    post "/play" do
      song_id = params["id"]
      if song_id
        song = LIBRARY.get_song(song_id.to_i)
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
