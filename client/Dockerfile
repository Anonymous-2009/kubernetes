# Base image for building
FROM node:iron-alpine AS builder 

# Initialize a working directory
WORKDIR /home/addifly-client

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the project
RUN npm run build 

# Base image for running
FROM node:iron-alpine AS runner 

# Initialize a working directory
WORKDIR /app

# Copy build output and necessary files
COPY --from=builder /home/addifly-client/dist ./dist
COPY --from=builder /home/addifly-client/node_modules ./node_modules
COPY --from=builder /home/addifly-client/package.json .
COPY --from=builder /home/addifly-client/package-lock.json .

# Expose ports
EXPOSE 4173 5173

# Start the application
CMD ["npm", "run", "preview"]