# encoding: UTF-8
require_relative 'utils'

s3creds = { access_key_id: 'S3_ACCESS_KEY_ID', secret_access_key: 'S3_SECRET_ACCESS_KEY', region: 'S3_REGION' }

ssh 'test.kodep.ru', user: 'root', password: 'qazxsw' do
  puts 'Try to do dump'
  make_dump :postgresql, database: 'kodep_dev', login: 'postgres', host: 'db_host', password: 'qwer1234', to_file: '/tmp/dump.psql'
  download 'dump.psql', to: '/tmp/dump.psql', server_name: 'test.kodep.ru', user_name: 'root', password: 'qazxsw', from_file: '/tmp/dump.psql'
end

s3 s3creds, bucket_name: 'bucket_name' do
  upload '/tmp/dump.psql'
end