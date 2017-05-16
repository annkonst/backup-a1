# encoding: UTF-8
require "backup/version"
require 'net/ssh'
require 'net/scp'

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
    end
  end

  def download(filename, params)
    if params[:password]
      Net::SCP.download!(params[:server_name], params[:user_name], filename, params[:to], ssh: { password: ENV['PASSWORD'] })
    else
      Net::SCP.download!(params[:server_name], params[:user_name], filename, params[:to])
    end
  end

  private

  def make_dump_mysql(params)
    @ssh.exec!("mysqldump -u #{params[:login]} -p #{params[:database]} > #{params[:to_file]}")
  end

  def make_dump_postgres(params)
    @ssh.exec!("pg_dump -U #{params[:login]} -O -h #{params[:host]} #{params[:database]} > #{params[:to_file]}")
  end
end

def ssh(server, params, &block)
  Utils.new(server, params, &block) if block_given?
end
