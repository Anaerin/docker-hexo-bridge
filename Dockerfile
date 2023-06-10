FROM node:slim

LABEL "org.opencontainers.image.authors"="Robert Johnston <me@anaer.in>"

# Set the server port as an environmental
ENV HEXO_SERVER_PORT=4000

# Install requirements
RUN \
 apt-get update && \
 npm install -g hexo-cli

# Set workdir
WORKDIR /app

# Expose Server Port
EXPOSE ${HEXO_SERVER_PORT}

# Build a base server and configuration if it doesnt exist, then start
CMD \
  if [ "$(ls -A /app)" ]; then \
    echo "***** App directory exists and has content, continuing *****"; \
  else \
    echo "***** App directory is empty, initialising with hexo and hexo-bridge *****" && \
    hexo init && \
    npm install && \
    npm install --save hexo-bridge && \
    echo "***** Updating config to point public folder to ../public *****" && \
    sed -i 's/^public_dir: public$/public_dir: ..\/public/' /app/_config.yml; \
  fi; \
  if [ ! -f /app/requirements.txt ]; then \
    echo "***** App directory contains no requirements.txt file, continuing *****"; \
  else \
    echo "***** App directory contains a requirements.txt file, installing npm requirements *****"; \
    cat /app/requirements.txt | xargs npm --prefer-offline install --save; \
  fi; \
  hexo generate --watch & \
  hexo server -p ${HEXO_SERVER_PORT}
