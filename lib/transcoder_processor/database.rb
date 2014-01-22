require 'sequel'
require 'singleton'

module TranscoderProcessor
  class Database

    include Singleton

    attr_reader :connection

    def self.connect!(string); instance.connect!(string); end

    def intialize
      @connection = false
    end

    def connect! string
      @connection = Sequel.connect(string)
    end

  end
end
