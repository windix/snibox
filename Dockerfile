FROM ruby:2.6-alpine3.9

RUN apk add --no-cache -t build-dependencies \
    build-base \
    postgresql-dev \
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

RUN gem install bundler -v 1.7.12 \
  && mkdir -p /usr/share/mime/packages \
  && curl https://cgit.freedesktop.org/xdg/shared-mime-info/plain/freedesktop.org.xml.in?h=Release-1-9 > /usr/share/mime/packages/freedesktop.org.xml \
  && FREEDESKTOP_MIME_TYPES_PATH=/usr/share/mime/packages/freedesktop.org.xml bundle install --deployment --without development test

COPY . ./

RUN SECRET_KEY_BASE=docker ./bin/rake assets:precompile && ./bin/yarn cache clean
