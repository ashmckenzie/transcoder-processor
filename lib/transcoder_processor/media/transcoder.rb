require 'pathname'

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
        register_start!
        response = Executor.new(command).execute!
        register_finish!(response)
        response
      end

      private

        attr_reader :media_file

        def register_start!
          media_file.update(
            status:                 Status::WORKING,
            started_processing_at:  Time.now
          )
        end

        def register_finish! response
          media_file.update(
            output_file_size:       output_file_size,
            status:                 response.status,
            job_exit_code:          response.exit_code,
            job_output:             response.output,
            finished_processing_at: Time.now
          )
        end

        def output_file_size
          if response.success?
            Pathname.new(media_file.output_file).size
          else
            0
          end
        rescue => e
          0
        end
    end

    class Executor

      def initialize command
        @command = command
      end

      def execute!
        output = `#{command}`
        exit_code = $?

        Response.new(output, exit_code)
      end

      private

        attr_reader :command
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

      def status
        success? ? Status::SUCCESSFUL : Status::FAILED
      end
    end
  end
end
