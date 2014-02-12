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
          @success ||= responses.detect { |x| !x.success? } ? false : true
        end

        def status
          success? ? Status::SUCCESSFUL : Status::FAILED
        end

        def output
          ''
        end

        private

          attr_accessor :responses
      end
    end
  end
end
