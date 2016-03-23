module Jukeborx
  class Song < ActiveRecord::Base
    def play
      spawn("afplay \"#{self.filename}\"")
    end

    def to_json(options=nil)
      {
        id:      self.id,
        artist:  self.artist,
        album:   self.album,
        title:   self.title,
        year:    self.year
      }.to_json
    end
  end
end
