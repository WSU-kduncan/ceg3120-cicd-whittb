# Use the official Node image as the base image
FROM node:18-bullseye

# Install Angular CLI globally to enable the "ng" command
RUN npm install -g @angular/cli

# Set the working directory inside the container
WORKDIR /app

# Copy the extracted Angular application from the repository into the container
COPY angular-site/angular-bird/ .

# Install project dependencies as specified in package.json
RUN npm install

# Optionally expose port 4200 (Angular's default port)
EXPOSE 4200

# Start the Angular application. The "--host 0.0.0.0" ensures it listens on all interfaces.
CMD ["ng", "serve", "--host", "0.0.0.0"]
