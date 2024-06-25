# Use the official Node.js image as the base image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install project dependencies using Yarn
RUN yarn install --immutable

# Copy the entire project directory into the container
COPY . .

# Expose the port the app runs on
EXPOSE 1337

# Define the command to run the app
CMD ["yarn", "develop"]
