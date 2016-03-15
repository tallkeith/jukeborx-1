require "sinatra/base"
require "pry"

require "jukeborx/version"

module Jukeborx
  class Api < Sinatra::Application

    get "/test" do
      "The API is up!"
    end

    run! if app_file == $0
  end
end
