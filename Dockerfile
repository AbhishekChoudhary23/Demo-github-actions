# Use a lightweight official Node image
FROM node:22-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy dependency definitions and install them
COPY package*.json ./
RUN npm install --only=production

# Copy the rest of your application code
COPY . .

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD [ "npm", "start" ]