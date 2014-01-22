require 'config'
require 'database'

TranscoderProcessor::Database.connect!(TranscoderProcessor::Config.instance.database.path)
