# Project Overview
This repository implements a modern continuous deployment pipeline for an Angular application. It is designed to automate the build, versioning, and deployment of containerized applications using GitHub Actions and DockerHub, with a final deployment to an EC2 instance.

## Repository Structure
Project 4/ Contains the main docker code and instructions for creating an image.

Project 5/ Contains the application code, configuration files, and documentation specific to the Angular project. This folder holds the source code and any associated assets for the frontend application.

deployment/ Contains all the files necessary for continuous deployment:

deploy.sh: A bash script that stops any running container, pulls the latest image from DockerHub, and launches the new container.

hooks.json: A webhook definition file used by adnanh's webhook to trigger the deployment script when a valid payload is received.

webhook.service: A systemd service file for Ubuntu that ensures the webhook listener starts automatically at boot and restarts if needed.

Dockerfile: A Dockerfile that builds the container image for the Angular application. It supports development workflows with ng serve and can be modified for production builds if necessary.

GitHub Actions Workflow Files Found in the .github/workflows/ directory, these YAML files define the CI process that:

- Triggers on semantic version tag pushes.
- Builds the Docker image.
- Uses the docker/metadata-action to generate image tags.
- Pushes the built image to DockerHub.

Documentation Files

- README-CI.md: Contains detailed instructions for the continuous integration process, including how the GitHub Actions workflows build and push the Docker image.
- README-CD.md: Contains detailed instructions on setting up continuous deployment, configuring the EC2 instance, Docker installation, webhook listener setup, and deployment testing.

Links

- [README-CI](../Project4/READEME-CI.md)
- [README-CD](../Project5/READEME-CD.md)
