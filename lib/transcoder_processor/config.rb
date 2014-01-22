require 'delegate'
require 'singleton'
require 'hashie'
require 'yaml'

module TranscoderProcessor
  class Config < SimpleDelegator

    include Singleton

    def initialize file='./config/config.yml'
      super(Hashie::Mash.new(YAML.load_file(file)))
    end
  end
end
