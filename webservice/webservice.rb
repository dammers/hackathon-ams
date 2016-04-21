require 'sinatra'
require 'json'
require 'aws-sdk'

$endpoint = 'https://10.65.57.176:8082'

creds = [Aws::Credentials.new('YSBDCQOZGH5NUG355HQY', 'DI/7+RyiQXtGM5yQhEoaouMX+phAZmXktvK6ctuN'),
         Aws::Credentials.new('YSBDCQOZGH5NUG355HQY', 'DI/7+RyiQXtGM5yQhEoaouMX+phAZmXktvK6ctuN'),
         Aws::Credentials.new('YSBDCQOZGH5NUG355HQY', 'DI/7+RyiQXtGM5yQhEoaouMX+phAZmXktvK6ctuN'),
         Aws::Credentials.new('YSBDCQOZGH5NUG355HQY', 'DI/7+RyiQXtGM5yQhEoaouMX+phAZmXktvK6ctuN'),
         Aws::Credentials.new('YSBDCQOZGH5NUG355HQY', 'DI/7+RyiQXtGM5yQhEoaouMX+phAZmXktvK6ctuN')]

clients = []
creds.each do |cred|
    clients << Aws::S3::Client.new(region: 'us-east-1', endpoint: $endpoint, credentials: cred, force_path_style: true, ssl_verify_peer: false)
end

clients[0].create_bucket(bucket: 'camera0')

get "/" do
  content_type :json
  { :message => "Webservice is running"}.to_json
end

get "/take_photo/:id" do
  content_type :json
  id = params[:id].to_i
  image_url = write_webcam_image_to_s3(clients[id], "camera#{id}")
  "Took photo for camera#{id}"
  { :message => "Took photo for camera#{id}",
    :image_url => image_url}.to_json
end

def write_webcam_image_to_s3(client, bucket)
  image_name = SecureRandom.hex(32) + ".jpg";
  # Take picture and store it as image_name
  puts "Taking picture with webcam and storing it as #{image_name}"
  
  # create fake file for testing
  File.open(image_name, "w") {}

  # Open Image file
  image_file = File.open(image_name, "r+")

  # Upload it to StorageGRID
  client.put_object(bucket: bucket, key: image_name,
    metadata: { 'foo' => 'bar' },
    body: image_file.read,
    server_side_encryption: 'AES256'
  )
  image_file.close
  File.delete(image_file)
  $endpoint + "/" + bucket + "/" + image_name
end
