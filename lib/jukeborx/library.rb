module Jukeborx
  class Library
    include Enumerable

    def initialize(dir)
      @songs = []
      get_mp3s(dir)
    end

    def each
      @songs.each { |x| yield(x) }
    end

    def match_artists(name)
      @songs.select { |song| song.artist =~ /#{name}/i  }
    end

    def match_albums(name)
      @songs.select { |song| song.album =~ /#{name}/i  }
    end

    def match_titles(name)
      @songs.select { |song| song.title =~ /#{name}/i  }
    end

    def list_artists
      @songs.map { |song| song.artist }.uniq
    end

    def list_albums
      @songs.map { |song| song.album }.uniq
    end

    def list_titles
      @songs.map { |song| song.title }.uniq
    end

    # def list_property(name)
    #   @songs.map { |song| song.send(name) }.uniq
    # end

    private
    def get_mp3s(dir)
      files = Dir.glob(File.join(dir, '*/*.mp3'))
      files.each_with_index do |mp3_file, id|
        begin
          tag = Mp3Info.open(mp3_file) { |mp3| mp3.tag }
          @songs << Song.new(id, mp3_file, tag)
        rescue Mp3InfoError => e
          puts "#{mp3_file} failed with: #{e.message}"
        rescue Encoding::InvalidByteSequenceError => e
          puts "Blew up trying to read: #{mp3_file}"
        end
      end
    end
  end
end
