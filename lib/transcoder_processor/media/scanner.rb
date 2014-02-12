require 'pathname'

module TranscoderProcessor
  module Media
    class Scanner

      FILE_EXTENSIONS = %w{ mkv avi mp4 mv4 mov iso }

      def initialize dir
        @dir = dir
      end

      def find
        files = Dir[::File.join(dir, '**', '*')].map do |f|
          extension = Pathname.new(f).extname[1..-1]
          if FILE_EXTENSIONS.include?(extension)
            File.new(f)
          end
        end.compact

        files
      end

      private

        attr_reader :dir
    end
  end
end
