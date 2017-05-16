require "backup/version"
require 'aws-sdk'

class S3Utils
  def initialize(auth_params, params &block)
    AWS.config(auth_params) 
    @s3 = AWS::S3.new
    @bucket = params[:bucket_name]

    unless bucket.exists?
      @s3.buckets.create(@bucket)
    end

    instance_eval &block if block_given?
  end

  def upload(file)
    bucket = @s3.buckets[@bucket]
    object = bucket.objects[File.basename(file]
    object.write(file: file) 
  end
end

def s3(auth_params, &block)
  S3Utils.new auth_params, &block if block_given?
end