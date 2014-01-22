require 'naught'
require 'sidekiq-status'

module TranscoderProcessor
  module Media
    class Status

      attr_reader :job_id

      def initialize job_id
        @job_id = job_id
      end

      def current
        Sidekiq::Status.status(job_id)
      end

      Sidekiq::Status::STATUS.each do |name|
        define_method "#{name}?" do
          Sidekiq::Status.send("#{name}?".to_sym, job_id)
        end
      end
    end

    StatusNull = Naught.build do |config|
      config.mimic Status
    end
  end
end
