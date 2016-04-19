# hackathon-ams


Two Services:

* webservice: Webservice based on Sinatra with Ruby. Runs on Rapsberry Pi. Will trigger the attached camera to a picture, then upload it to an S3 target. 
* webclient: Containerized website, running on Sinatra with Ruby. Will connect to the webservice and then display the last 10 pictures taken.

## Usage

### webservice

* `docker build .` builds the container
* `docker run -p 8080:8080 <image_id>` runs the container
* `docker ps` lists all running containers
* `docker kill <id>` kills an running container

Once the container runs, you can access it via `http://localhost:8080`

You can also run the webservice manually:
* `shotgun --host 0.0.0.0 --port 8080 server.rb`

However, you will need to have the following gems installed:
* `gem install shotgun`
* `gem install aws-sdk`

### webclient
