require_relative '../notify_me_client'

module TranscoderProcessor
  class Notification

    def initialize media_file_id
      @media_file_id = media_file_id
    end

    def notify!
      NotifyMeClient.new(api_key).notify!(title, message)
    end

    private

      attr_reader :media_file_id

      def api_key
        TranscoderProcessor::Config.instance.app.notify_me.api_key
      end

      def title
        "#{media_file.output_file.basename.to_s} transcoded!"
      end

      def message
        %Q{#{media_file.output_file} (#{media_file.output_file_size})\n\nTook #{media_file.processing_time[:diff]}}
      end

      def media_file
        TranscoderProcessor::Models::MediaFile.find(id: media_file_id)
      end
  end
end
