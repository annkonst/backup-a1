require 'net/scp'

module DownloadDump
  class ScpDownload
		Net::SCP.download!(ENV['SERVER_NAME'], ENV['USER_NAME'], "/tmp/test_dump.psql", ENV['LOCAL_PATH'], ssh: { password: ENV['PASSWORD'], port: ENV['PORT'] })
	end
end