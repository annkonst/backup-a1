require 'net/ssh'

module ConnectToServer
  class SshConnection
    Net::SSH.start( ENV['SERVER_NAME'], ENV['USER_NAME'], password: ENV['PASSWORD'], port: ENV['PORT']) do |ssh|
      data = ssh.exec!("pg_dump -U $DB_USER -O -h $DB_HOST $DB_NAME > /tmp/test_dump.psql")
      ssh.close()
    end
  end
end