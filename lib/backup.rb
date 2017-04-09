require "backup/version"
require 'net/ssh'
require 'net/scp'
require 'aws-sdk'

module Backup
  require 'backup/connect_to_server'
  require 'backup/download_dump'
  require 'backup/save_to_s3'
end
