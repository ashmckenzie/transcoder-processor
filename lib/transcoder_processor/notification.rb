module TranscoderProcessor
  class Notification

    def initialize media_file_id
      @media_file_id = media_file_id
    end

    def notify!
      PushoverSender::Notification.new.notify!(title, message)
    end

    private

      attr_reader :media_file_id

      def title
        "#{media_file.output_file.basename.to_s} transcoded!"
      end

      def message
        %Q{#{media_file.input_file} (#{media_file.input_file_size})\n\n#{media_file.output_file} (#{media_file.output_file_size})\n\nTook #{media_file.processing_time[:diff]}}
      end

      def media_file
        TranscoderProcessor::Models::MediaFile.find(id: media_file_id)
      end
  end
end
