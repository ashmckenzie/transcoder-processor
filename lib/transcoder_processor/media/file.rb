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

      def output_file
        ::File.join(TranscoderProcessor::Config.instance.downloads.tmp_dir, filename)
      end

      def size
        Filesize.from("#{file.size} B").pretty
      end

      def media_file
        Models::MediaFile.for(file.to_s)
      end

      def status
        media_file.status
      end

      def transcode!
        Models::MediaFile.transcode!(file.to_s, output_file)
      end
    end
  end
end
