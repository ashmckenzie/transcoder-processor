module TranscoderProcessor
  module Media
    module Transcoder
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
    end
  end
end
