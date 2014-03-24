require 'pathname'
require 'fileutils'

require_relative '../../../file_man'

module TranscoderProcessor
  module Media
    module Transcoder
      class Controller

        def initialize media_file
          @media_file = media_file
        end

        def execute!
          response = ResponseChain.new

          register_start!
          ensure_output_directory_exists!

          response << Executor.new(command).execute!
          response << Executor.new(sample_command).execute!

          register_finish!(response)

          response
        end

        private

          attr_reader :media_file

          def command
            Command.new(full_input_file, output_file).line
          end

          def sample_command
            opts = { start_at: 300, stop_at: 120 }
            Command.new(full_input_file, sample_output_file, opts).line
          end

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
            ::File.join(Config.instance.downloads.dir, media_file.input_file)
          end

          def output_file_raw
            FileMan.new(::File.join(TranscoderProcessor::Config.instance.downloads.tmp_dir, media_file.input_file))
          end

          def output_file
            file = output_file_raw
            file.extension = 'mkv'
            file.filename_without_extension = "#{file.filename_without_extension}.transcoded"
            file.to_s
          end

          def sample_output_file
            file = output_file_raw
            file.extension = 'mkv'
            file.filename_without_extension = "#{file.filename_without_extension}.sample"
            file.to_s
          end

          def base_output_directory
            Pathname.new(output_file.to_s).dirname
          end

          def output_file_size response
            response.success? ? Pathname.new(media_file.output_file).size : 0
          end
      end
    end
  end
end
