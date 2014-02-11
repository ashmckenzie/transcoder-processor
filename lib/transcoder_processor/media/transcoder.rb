require 'pathname'
require 'fileutils'

module TranscoderProcessor
  module Media
    class Transcoder

      def initialize media_file
        @media_file = media_file
      end

      def command
        %Q{HandBrakeCLI --format mkv --encoder x264 --vb 1500 --subtitle 1,2,3,4 --subtitle-forced --subtitle-default --vfr --two-pass --turbo --input "#{full_input_file}" --output "#{output_file}" 2>&1}
      end

      def execute!
        register_start!
        ensure_output_directory_exists!
        response = Executor.new(command).execute!
        register_finish!(response)
        response
      end

      private

        attr_reader :media_file

        def nodename
          `uname -n`.chomp
        end

        def ensure_output_directory_exists!
          FileUtils.mkdir_p(base_output_directory)
        end

        def register_start!
          media_file.update(
            status:                 Status::WORKING,
            started_processing_at:  Time.now,
            job_processor:          nodename,
            output_file:            output_file
          )
        end

        def register_finish! response
          media_file.update(
            output_file_size:       output_file_size(response),
            status:                 response.status,
            job_exit_code:          response.exit_code,
            job_output:             response.output,
            finished_processing_at: Time.now
          )
        end

        def full_input_file
          ::File.join(TranscoderProcessor::Config.instance.downloads.dir, media_file.input_file)
        end

        def output_file
          ::File.join(TranscoderProcessor::Config.instance.downloads.tmp_dir, media_file.input_file)
        end

        def base_output_directory
          Pathname.new(output_file).dirname
        end

        def output_file_size response
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
