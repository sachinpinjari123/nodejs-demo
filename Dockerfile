FROM node:16-alpine

WORKDIR /app
COPY package*.json ./
RUN npm config set cache /app/.npm-cache --global && npm install
COPY . .
EXPOSE 8080
CMD ["npm", "start"]
