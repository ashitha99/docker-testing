
# Use the official Node.js 14 image as the base image
FROM node:18

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Strapi admin panel
RUN npm run build

# Expose the port that the Strapi application will run on
EXPOSE 1337

# Start the Strapi application
CMD ["npm", "run", "start"]