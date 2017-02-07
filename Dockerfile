FROM ruby:2.4-alpine
MAINTAINER Sebastian Schkudlara "sebastian.schkudlara@vizzuality.com"

ENV BUILD_PACKAGES bash curl-dev build-base libxml2-dev libxslt-dev postgresql-dev nodejs

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN gem install bundler --no-ri --no-rdoc

# Use libxml2, libxslt a packages from alpine for building nokogiri
RUN bundle config build.nokogiri

RUN mkdir /fti

WORKDIR /fti
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5

ADD . /fti

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
