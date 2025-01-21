# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy only package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install all dependencies (including development dependencies)
RUN npm install

# Copy the rest of the application source code
COPY . .

# Stage 2: Production Stage
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only the production dependencies from the builder stage
COPY --from=builder /app/node_modules /app/node_modules

# Copy the application source code from the builder stage
COPY --from=builder /app .

# Expose the application port
EXPOSE 8000

# Command to start the server
CMD ["node", "server.js"]
