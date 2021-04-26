FROM node:15-alpine3.10

# set working directory
WORKDIR /app
# copy project file
COPY package.json .
# install node packages
RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install
# copy app files
COPY src/index.js .
# run linter, setup and tests
EXPOSE 3000
CMD ["node", "index.js"]