require 'pathname'
require 'filesize'

module TranscoderProcessor
  module Media
    class File

      attr_reader :file

      def initialize file
        @file = Pathname.new(file.to_s)
        raise 'File does not exist!' unless @file.exist?
      end

      def filename
        file.basename.to_s
      end

      def file_minus_download_dir
        regex = Regexp.new("#{download_dir}/")
        file.to_s.gsub(regex, '')
      end

      def size
        Filesize.from("#{file.size} B").pretty
      end

      def status
        media_file.status
      end

      def started_processing_at
        media_file.started_processing_at
      end

      def finished_processing_at
        media_file.finished_processing_at
      end

      def transcode!
        Models::MediaFile.transcode!(self)
      end

      def media_file
        Models::MediaFile.for(self)
      end

      private

        def download_dir
          TranscoderProcessor::Config.instance.downloads.dir
        end
    end
  end
end
