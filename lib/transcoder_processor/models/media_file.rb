# TranscoderProcessor::Database.instance.connection.create_table :media_files do
#   primary_key :id
#   String :input_file
#   Bignum :input_file_size
#   String :output_file
#   Bignum :output_file_size, default: 0
#   String :status
#   String :job_id
#   DateTime :created_at
#   DateTime :updated_at
#   DateTime :started_processing_at
#   DateTime :finished_processing_at
# end

require 'pathname'
require 'naught'
require 'time_diff'

require 'media/status'

module TranscoderProcessor
  module Models
    class MediaFile < Sequel::Model

      plugin :timestamps, :update_on_create => true

      def status
        Media::Status.new(job_id)
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

      def self.for input_file
        if row = where(input_file: input_file).first
          row
        else
          MediaFileNull.new
        end
      end

      def self.transcode! input_file, output_file
        record = create(
          input_file:       input_file,
          input_file_size:  Pathname.new(input_file).size,
          output_file:      output_file
        )

        if job_id = Workers::TranscoderWorker.perform_async(record.id)
          record.job_id = job_id
          record.save
        else
          raise 'Ruh roh'
        end
      end
    end

    MediaFileNull = Naught.build do |config|
      config.mimic MediaFile

      def status
        Media::StatusNull.new
      end
    end
  end
end
