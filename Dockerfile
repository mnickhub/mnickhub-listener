FROM ruby:2.7.4-alpine3.14

EXPOSE 3000

RUN mkdir /app
COPY . /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    # give user ownership over app directory
    chown -R appuser:appgroup /app

USER appuser

WORKDIR /app

RUN gem install bundler:1.17.2 && \
    bundle install

CMD bundle exec ruby listener_server.rb




