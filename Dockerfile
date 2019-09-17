# Start with a node 8.16 slim image to keep the container size down
FROM node:8.16-jessie-slim

# Specify a default directory for where our app will be placed within the container. 
#
# This can be overridden with docker build --build-arg WORKDIR=some-dir/ .
# Always append the directory name with a /
ARG WORKDIR=/opt/apps/ration/

# Create a directory to contain our application
RUN mkdir -p $WORKDIR

# Switch default working directory to our new directory
WORKDIR $WORKDIR

# Copy our package and lock files over first, 
# as the build can then cache this step seperately from our code.
# 
# This allows us to build faster when we only have code changes, 
# as the install step will be loaded from cache, 
# and rebuilt when package files change
COPY package.json package-lock.json $WORKDIR

# Install the actual dependencies
RUN npm install

# Now copy over your actual source code
# 
# REMEMBER: We are ignoring node_modules in the .dockerignore file explicitly, 
# so docker will not copy over that directory. The app will use th modules installed above.
COPY . $WORKDIR

# Set the default CMD to run when starting this image. 
# 
# You can easily override this when running the image
CMD npm start
