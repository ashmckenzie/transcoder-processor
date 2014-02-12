module TranscoderProcessor
  module Models
    NullMediaFile = Naught.build do |config|
      config.mimic MediaFile

      def status
        Status.new
      end

      def job_processor
        '-'
      end
    end
  end
end
