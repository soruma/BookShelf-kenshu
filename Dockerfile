FROM ruby:2.5

EXPOSE 3000

RUN apt update -qq \
 && apt-get install -y --no-install-recommends \
    build-essential libpq-dev nodejs \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

RUN bundle config build.nokogiri --use-system-libraries

CMD [ "rails s" ]
