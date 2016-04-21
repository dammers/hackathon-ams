require 'sinatra'
require 'haml'
require 'aws-sdk'

endpoint = 'https://' + ENV['STORAGEGRID_HOST'] + ':8082'
credentials = Aws::SharedCredentials.new(profile_name: ENV['S3_PROFILE'])
s3 = Aws::S3::Client.new(region: 'us-east-1', endpoint: endpoint,
                         credentials: credentials, force_path_style: true,
                         ssl_verify_peer: false)

get "/" do
  haml :index
end

post "/upload" do 
  key = SecureRandom.hex(32);
  s3.put_object(bucket: 'fileshare', key: key,
    metadata: { 'sender' => params['sender'], 'message' => Base64.strict_encode64(params['message']),
                'filename' => params['file'][:filename] },
    body: params['file'][:tempfile].read,
    server_side_encryption: 'AES256'
  )
  @id = key
  haml :success
end

get "/:id" do
  @id = params[:id]
  head = s3.head_object(bucket: 'fileshare', key: @id)
  @sender = head.metadata['sender']
  @message = Base64.strict_decode64(head.metadata['message'])
  @filename = head.metadata['filename']
  @size = (head.content_length.to_i / 1024.0 / 1024.0).round(1)
  haml :download
end

get "/download/:id" do
  key = params[:id]
  filename = s3.head_object(bucket: 'fileshare', key: key).metadata['filename']
  tempfile = Tempfile.new("temp", "temp/")
  s3.get_object(bucket: 'fileshare', key: key, response_target: tempfile.path)
  send_file tempfile.path, :filename => filename, :type => 'Application/octet-stream'
end
