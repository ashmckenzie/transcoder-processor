module TranscoderProcessor
  module Media
    module Transcoder
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
end
