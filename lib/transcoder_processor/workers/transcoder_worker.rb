require 'sidekiq'

module TranscoderProcessor
  module Workers
    class TranscoderWorker

      include Sidekiq::Worker

      QUEUE_NAME = :default
      sidekiq_options :queue => QUEUE_NAME

      def perform media_file_id
        if media_file = TranscoderProcessor::Models::MediaFile.find(id: media_file_id)
          response = TranscoderProcessor::Media::Transcoder::Controller.new(media_file).execute!

          if response.success?
            NotificationWorker.perform_async(media_file_id)
          end
        end
      end
    end
  end
end
