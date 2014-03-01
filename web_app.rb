require 'sinatra/base'
require 'sinatra/reloader'
require 'better_errors'
require 'rack/cache'
require 'json'
require 'ostruct'

require_relative './config/initialise'

class WebApp < Sinatra::Base

  configure :development do
    require 'pry'
    require 'awesome_print'

    register Sinatra::Reloader

    lib_path = File.expand_path(File.join('..', 'lib', 'transcoder_processor', '**', '*.rb'), __FILE__)

    Dir[lib_path].each do |file|
      also_reload file
    end

    use BetterErrors::Middleware
  end

  get '/' do
    @data = data

    erb :index
  end

  post '/transcode' do
    TranscoderProcessor::Media::File.new(params[:file]).transcode!
    ''
  end

  post '/cancel-transcode' do
    TranscoderProcessor::Models::MediaFile.find(id: params[:id]).unqueue!
    ''
  end

  get '/about' do
    erb :about
  end

  private

    def data
      OpenStruct.new(
        files: files
      )
    end

    def files
      TranscoderProcessor::Media::Scanner.new(download_dir).find
    end

    def download_dir
      TranscoderProcessor::Config.instance.downloads.dir
    end
end
