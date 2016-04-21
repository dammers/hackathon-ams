FROM training/sinatra
MAINTAINER Clemens Siebler <clemens.siebler@gmail.com>

RUN gem install shotgun
RUN gem install aws-sdk
RUN gem install unirest

RUN mkdir /sinatra
COPY webclient.rb /sinatra

EXPOSE 8081
ENTRYPOINT shotgun --host 0.0.0.0 --port 8081 /sinatra/webclient.rb