FROM node:v14.21.3
FROM ruby:3.0.6

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update \
    && apt-get install -y nodejs npm redis-server\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && hash -r
RUN npm install npm@latest -g && \
    npm install n -g && \
    n latest
RUN npm install -g yarn@latest
RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle install

COPY . /app

RUN yarn install
RUN echo -ne '\n' | npx browserslist@latest --update-db
RUN cd /app/
CMD ["/bin/bash"]
