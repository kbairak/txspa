FROM node:13.5-alpine3.11

ARG USER_ID
ARG GROUP_ID

# Alpine specific user commands
# Running containers as root is a bad practice. Therefore we have added
# the USER_ID and GROUP_ID values so that we can declare with which uid/gid
# containers will be running. If we don't pass those ARG then docker
# will ignore them and will run container as normal
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    deluser node &&\
    if getent group node ; then groupdel node; fi &&\
    addgroup -g ${GROUP_ID} node &&\
    adduser -u ${USER_ID} -D node -G node && \
    install -d -m 0755 -o node -g node /home/node \
;fi

# Create app directory
RUN mkdir -p /usr/app && \
    chown -R node:node /usr/app
WORKDIR /usr/app

USER node

# Install app dependencies
COPY package.json .
COPY package-lock.json .

RUN npm install

COPY public ./public
COPY src ./src

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

EXPOSE 3000
CMD ["npm", "run", "start"]
