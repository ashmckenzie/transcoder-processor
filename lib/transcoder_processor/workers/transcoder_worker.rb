require 'sidekiq'
require 'sidekiq-status'

module TranscoderProcessor
  module Workers
    class TranscoderWorker

      include Sidekiq::Worker
      include Sidekiq::Status::Worker

      def perform media_file_id
        media_file = TranscoderProcessor::Models::MediaFile.find(id: media_file_id)
        response = TranscoderProcessor::Media::Transcoder.new(media_file).execute!

        if response.success?
          NotificationWorker.perform_async(media_file_id)
        end
      end
    end
  end
end
