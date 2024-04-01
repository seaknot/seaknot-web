FROM torus/violet:latest

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g nodemon

WORKDIR /code
CMD make run
