# encoding: UTF-8

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

namespace 'transcoder-processor' do

  desc 'Console'
  task :console do
    require 'pry'
    require 'pry-debugger'
    require 'awesome_print'

    include TranscoderProcessor

    pry
  end

  task :clear_jobs do
    Sidekiq.redis { |x| x.del(x.keys) unless x.keys.empty? }
  end
end
