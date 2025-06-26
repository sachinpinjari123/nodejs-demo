# Use official Node.js image
FROM node:18

# Create app directory and switch to it
WORKDIR /app

# Copy package.json and install dependencies as root
COPY package*.json ./
RUN npm install

# Copy the rest of the code
COPY . .

# Change ownership to non-root user (node user exists in official node image)
RUN chown -R node:node /app

# Switch to non-root user
USER node

# Expose port
EXPOSE 8080

# Run app
CMD ["npm", "start"]
