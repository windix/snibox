FROM ruby:2.6-alpine3.9

RUN apk add --no-cache -t build-dependencies \
    build-base \
    sqlite-dev \
  && apk add --no-cache \
    git \
    tzdata \
    curl \
    nodejs \
    yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./

ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV NODE_ENV=production

RUN mkdir -p /usr/share/mime/packages
COPY docker-build/freedesktop.org.xml /usr/share/mime/packages/freedesktop.org.xml

RUN gem install bundler -v 1.7.12 \
  && mkdir -p /usr/share/mime/packages \
  && FREEDESKTOP_MIME_TYPES_PATH=/usr/share/mime/packages/freedesktop.org.xml bundle install --deployment --without development test

COPY . ./

RUN SECRET_KEY_BASE=docker ./bin/rake assets:precompile && ./bin/yarn cache clean
