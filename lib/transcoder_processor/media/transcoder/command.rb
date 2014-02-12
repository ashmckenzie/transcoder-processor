
module TranscoderProcessor
  module Media
    class Command

      def initialize input_file, output_file, opts={}
        @input_file = input_file
        @output_file = output_file

        opts[:start_at] = opts.fetch(:start_at, false)
        opts[:stop_at] = opts.fetch(:stop_at, false)
        @opts = opts
      end

      def line
        line = [
          'HandBrakeCLI',
          '--format mkv',
          '--encoder x264',
          '--vb 1500',
          '--subtitle 1,2,3,4',
          '--subtitle-forced',
          '--subtitle-default',
          '--vfr',
          '--two-pass',
          '--turbo',
          '--optimize',
          '--large-file',
          '--markers'
        ]

        line << "--start-at duration:#{opts[:start_at]}" if opts[:start_at]
        line << "--stop-at duration:#{opts[:stop_at]}" if opts[:stop_at]

        line << %Q{--input "#{input_file}"}
        line << %Q{--output "#{output_file}" 2>&1}

        line.join(' ')
      end

      private

        attr_reader :opts, :input_file, :output_file
    end
  end
end
