require 'sinatra'
require 'aws-sdk'
require 'unirest'

url = 'https://10.65.57.176:8082'

cred = Aws::Credentials.new('YSBDCQOZGH5NUG355HQY', 'DI/7+RyiQXtGM5yQhEoaouMX+phAZmXktvK6ctuN')
client = Aws::S3::Client.new(region: 'us-east-1', endpoint: url, credentials: cred, force_path_style: true, ssl_verify_peer: false)


get "/" do
  haml :index
end

get "/take_photo/" do
  response = Unirest.get "http://localhost:8080/take_photo/0"

  @image_url = response.body['image_url'].to_s
  haml :show_photo
end