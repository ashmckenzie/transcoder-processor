# TranscoderProcessor::Database.instance.connection.drop_table :media_files

# TranscoderProcessor::Database.instance.connection.create_table :media_files do
#   primary_key :id

#   String :input_file
#   Bignum :input_file_size
#   String :output_file
#   Bignum :output_file_size, default: 0
#   String :status, default: 'nothing'
#   String :job_processor
#   String :job_id
#   String :job_output
#   Integer :job_exit_code
#   DateTime :created_at
#   DateTime :updated_at
#   DateTime :started_processing_at
#   DateTime :finished_processing_at
# end

require 'pathname'
require 'naught'
require 'time_diff'

module TranscoderProcessor
  module Models
    class MediaFile < Sequel::Model

      plugin :validation_helpers
      plugin :timestamps, :update_on_create => true

      def self.for file
        if row = find(input_file: file.file_minus_download_dir)
          row
        else
          NullMediaFile.new
        end
      end

      def status
        Status.new(self[:status].to_sym)
      end

      def processing_time
        Time.diff(self[:started_processing_at], self[:finished_processing_at], '%h:%m:%s')
      end

      def input_file_size
        Filesize.from("#{self[:input_file_size]} B").pretty
      end

      def input_file
        Pathname.new(self[:input_file])
      end

      def output_file_size
        Filesize.from("#{self[:output_file_size]} B").pretty
      end

      def output_file
        Pathname.new(self[:output_file])
      end

      def unqueue!
        if status.enqueued?
          if Sidekiq::Queue.new.find_job(job_id).delete
            update(status: Status::NOTHING)
          end
        else
          raise "Not enqueued! (#{})"
        end
      end

      def self.transcode! file
        input_file = file.file_minus_download_dir

        unless record = find(input_file: input_file)
          record = create(
            input_file:       input_file,
            input_file_size:  Pathname.new(file.file).size
          )
        end

        if job_id = Workers::TranscoderWorker.perform_async(record.id)
          record.update(
            status: Status::ENQUEUED,
            job_id: job_id
          )
        else
          raise 'Ruh roh'
        end
      end
    end
  end
end
