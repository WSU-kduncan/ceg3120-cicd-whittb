# Use the official Node image as the base image
FROM node:18-bullseye

# Install Angular CLI globally so we can use the "ng" command
RUN npm install -g @angular/cli

# Set the working directory inside the container where our app will live
WORKDIR /app

# Copy the contents of the "angular-site" folder from your repository into the container
COPY Project4/angular-site/ .

# Install the project dependencies declared in package.json
RUN npm install

# Optionally, expose port 4200 (the default port for Angular)
EXPOSE 4200

# Run the Angular application. The "--host 0.0.0.0" option makes the app accessible externally.
CMD ["ng", "serve", "--host", "0.0.0.0"]
