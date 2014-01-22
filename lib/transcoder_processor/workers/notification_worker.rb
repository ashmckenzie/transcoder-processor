require 'sidekiq'
require 'pushover_sender'

module TranscoderProcessor
  module Workers
    class NotificationWorker

      include Sidekiq::Worker

      def perform media_file_id
        media_file = TranscoderProcessor::Models::MediaFile.find(id: media_file_id)

        title = "#{media_file.output_file.basename.to_s} transcoded!"
        message = %Q{#{media_file.input_file} (#{media_file.input_file_size})\n\n#{media_file.output_file} (#{media_file.output_file_size})\n\nTook #{media_file.processing_time[:diff]}}

        PushoverSender::Notification.new.notify!(title, message)
      end
    end
  end
end
