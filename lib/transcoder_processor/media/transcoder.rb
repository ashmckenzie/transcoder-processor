module TranscoderProcessor
  module Media
    class Transcoder

      def initialize media_file
        @media_file = media_file
      end

      def command
        %Q{HandBrakeCLI --format mkv --encoder x264 --vb 1500 --audio English --subtitle English --vfr --two-pass --turbo --input "#{media_file.input_file}" --output "#{media_file.output_file}" 2>&1}
      end

      def execute!
        media_file.update(started_processing_at: Time.now)
        output = `#{command}`
        exit_code = $?
        media_file.update(finished_processing_at: Time.now)

        # FIXME: this isn't great
        media_file.update(status: :complete, job_exit_code: exit_code, job_output: output)

        Response.new(output, exit_code)
      end

      private

        attr_reader :media_file
    end

    class Response

      attr_reader :output, :exit_code

      def initialize output, exit_code
        @output = output
        @exit_code = exit_code
      end

      def success?
        exit_code.success?
      end
    end
  end
end
