module Jukeborx
  class Song
    attr_reader :id, :filename, :artist, :album, :title, :year

    def initialize(id, file, tag)
      @id = id
      @filename = file
      @artist = tag.artist
      @album = tag.album
      @title = tag.title
      @year = tag.year
    end

    def play
      spawn("afplay \"#{@filename}\"")
    end

    def to_json
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
