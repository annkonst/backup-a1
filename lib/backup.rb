require "backup/version"
require 'net/ssh'
require 'net/scp'
require 'aws-sdk'

module Backup
  module_function

  def make_backup
    ssh_start
    download_dump_from_server
    upload_dump_to_s3
  end

  def ssh_start
    Net::SSH.start( ENV['SERVER_NAME'], ENV['USER_NAME'], password: ENV['PASSWORD'], port: ENV['PORT']) do |ssh|
      ssh.exec!("pg_dump -U $DB_USER -O -h $DB_HOST $DB_NAME > /tmp/test_dump.psql")
      ssh.close()
    end
  end

  def download_dump_from_server
    Net::SCP.download!(ENV['SERVER_NAME'], ENV['USER_NAME'], "/tmp/test_dump.psql", ENV['LOCAL_PATH'], ssh: { password: ENV['PASSWORD'], port: ENV['PORT'] })
  end

  def upload_dump_to_s3
    AWS.config(
      access_key_id: ENV['S3_ACCESS_KEY_ID'],
      secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
      region: ENV['S3_REGION']
    ) 

    s3 = AWS::S3.new

    unless bucket.exists?
      s3.buckets.create(ENV['BUCKET_NAME'])
    end

    bucket = s3.buckets[ENV['BUCKET_NAME']]
    object = bucket.objects[File.basename(ENV['SOURCE_FILENAME'])]
    object.write(file: ENV['SOURCE_FILENAME']) 
  end

end

Backup.make_backup
