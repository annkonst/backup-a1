# encoding: UTF-8
require "backup/version"
require 'net/ssh'
require 'net/scp'
require 'aws-sdk'

class Utils
  def initialize(server, params, &block)
    Net::SSH.start(server: server, user: params[:user], password: params[:password]) do |ssh|
      @ssh = ssh
      instance_eval &block if block_given?
      @ssh.close
    end
  end

  def make_dump(database_server, params)
    case database_server
    when :postgresql
      make_dump_postgres(params)
    when :mysql
      make_dump_mysql(params)
    else
      puts "I don't know this database server"
    end
  end

  def download(filename, params)
    if params[:password]
      Net::SCP.download!(params[:server_name], params[:user_name], filename, params[:to], ssh: { password: ENV['PASSWORD'] })
    else
      Net::SCP.download!(params[:server_name], params[:user_name], filename, params[:to])
    end
    puts "Download #{filename}, params: #{params}"
  end

  private

  def make_dump_mysql(params)
    @ssh.exec!("mysqldump -u #{params[:login]} -p #{params[:database]} > #{params[:to_file]}")
    puts "Making database dump for mysql with params: #{params}"
  end

  def make_dump_postgres(params)
    @ssh.exec!("pg_dump -U #{params[:login]} -O -h #{params[:host]} #{params[:database]} > #{params[:to_file]}")
    puts "Making database dump for mysql with params: #{params}"
  end
end

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
    puts "Uploading file #{file} to s3 with params #{params}"
  end
end

def ssh(server, params, &block)
  Utils.new(server, params, &block) if block_given?
end

def s3(auth_params, &block)
  puts "Connect to s3 with #{auth_params}"
  S3Utils.new auth_params, &block if block_given?
end
