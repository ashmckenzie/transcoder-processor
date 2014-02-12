module TranscoderProcessor
  module Media
    module Transcoder
      class ResponseChain

        def initialize
          @responses = []
        end

        def <<(response)
          @responses << response
        end

        def success?
          @success ||= (responses.detect { |x| !x.success? }) ? false : true
        end

        def status
          success? ? Status::SUCCESSFUL : Status::FAILED
        end

        def exit_code
          exit_code = -1

          responses.each do |x|
            exit_code = if (x.exit_code.exitstatus > exit_code)
              x.exit_code.exitstatus
            else
              exit_code
            end
          end

          exit_code
        end

        def output
          responses.map { |x| x.output }.join("\n\n").chomp
        end

        private

          attr_accessor :responses
      end
    end
  end
end
