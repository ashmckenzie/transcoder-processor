require 'sidekiq'

module TranscoderProcessor
  module Workers
    class NotificationWorker

      include Sidekiq::Worker

      QUEUE_NAME = :high
      sidekiq_options :queue => QUEUE_NAME

      def perform media_file_id
        Notification.new(media_file_id).notify!
      end
    end
  end
end
