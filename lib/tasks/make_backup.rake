# encoding: UTF-8
require 'backup/version'
require_relative 'backup/ssh_utils'
require_relative 'backup/s3_utils'

namespace :db do
  task :make_backup do
    s3creds = { access_key_id: 'S3_ACCESS_KEY_ID', secret_access_key: 'S3_SECRET_ACCESS_KEY', region: 'S3_REGION' }

    ssh 'server_name', user: 'user_name', password: 'password' do
	  make_dump :postgresql, database: 'db_name', login: 'login', host: 'db_host', password: 'password', to_file: 'file_path'
	  download 'dump_name', to: 'file_to_path', server_name: 'server_name', user_name: 'user_name', password: 'password', from_file: 'file_path'
	end

	s3 s3creds, bucket_name: 'bucket_name' do
	  upload 'file_path'
	end
  end
end
