require 'aws-sdk'

module DownloadDump
  class ScpDownload

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