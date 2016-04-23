FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential postgresql postgresql-contrib libpq-dev libgeos-dev libproj-dev
RUN ln -sf /usr/lib/libgeos-3.4.2.so /usr/lib/libgeos.so && ln -sf /usr/lib/libgeos-3.4.2.so /usr/lib/libgeos.so.1

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN RAILS_ENV=staging bundle exec rake assets:precompile --trace
CMD ["rails", "server", "Puma", "-e", "staging", "-b", "0.0.0.0"]
