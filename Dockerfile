######################
# Stage: Builder
FROM ruby:2.4.7-slim as Builder

ARG FOLDERS_TO_REMOVE
ARG BUNDLE_WITHOUT
ARG RAILS_ENV
#ARG EXECJS_RUNTIME

ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}
ENV RAILS_ENV ${RAILS_ENV}
#ENV EXECJS_RUNTIME ${EXECJS_RUNTIME}

# Install System libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    gnupg \
    curl \
    python \
  && rm -rf /var/lib/apt/lists/*

# Install nodejs
# gpg keys listed at https://github.com/nodejs/node#release-keys
RUN set -ex \
  && for key in \
    4ED778F539E3634C779C87C6D7062848A1AB005C \
    B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
  ; do \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 10.16.3

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Install yarn
ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN set -ex && \
    apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile* ./

RUN bundle config --global frozen 1 \
  && bundle install --jobs=4 --retry=3 \
  # Remove unneeded files (cached *.gem, *.o, *.c)
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy the app
COPY . .

## Build frontend
#RUN set -ex \
#    && echo '{ "allow_root": true }' > /root/.bowerrc \
#    && bundle exec rake mnoe:frontend:build

# Build admin panel
RUN set -ex \
    && echo '{ "allow_root": true }' > /root/.bowerrc \
    && bundle exec rake mnoe:admin:build


# Remove folders not needed in resulting image
RUN rm -rf $FOLDERS_TO_REMOVE

###############################
# Stage Final
FROM ruby:2.4.7-slim
MAINTAINER developpers@maestrano.com

ARG ADDITIONAL_PACKAGES
ARG EXECJS_RUNTIME

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/maestrano/mno-enterprise-demo" \
      org.label-schema.vendor="Maestrano" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

## TODO: remove curl and use nc for healthcheck?
#RUN apk add --update --no-cache \
#        curl \
#        tzdata

# Add user
RUN addgroup --system --gid 1000 app \
 && adduser --system --uid 1000 --ingroup app app

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app /app /app

USER app

# Set Rails env
ENV RAILS_LOG_TO_STDOUT true

WORKDIR /app

# Save timestamp of image building
RUN date -u > BUILD_TIME

ENTRYPOINT ["docker/entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
