require "sinatra/base"
require "mp3info"
require "pry"

require "jukeborx/version"
require "jukeborx/song"
require "jukeborx/library"

MUSIC_DIR = "/Users/brit/Music/downloads"

module Jukeborx
  class Api < Sinatra::Application
    set :library, Library.new(MUSIC_DIR)

    get "/test" do
      "The API is up!"
    end

    ## Params:
    ##  type (required) - One of 'artist', 'album', 'title'
    ##  value - "radiohead", "supermodified", "bad blood"
    get "/api/search" do
      if params["type"] == "artist"
        settings.library.match_artists(params["value"])
      elsif params["type"] == "album"
        settings.library.match_albums(params["value"])
      elsif params["type"] == "title"
        settings.library.match_titles(params["value"])
      else
        { error: "Invalid search type." }.to_json
      end
    end

    run! if app_file == $0
  end
end
