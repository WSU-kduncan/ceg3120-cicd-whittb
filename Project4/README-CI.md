# Project Overview: 

- What is the goal of this project
- What tools are used in this project and what are their roles
- Diagram of project

## Part 1:

1. Docker Setup
    - How to install Docker for your OS
        - Download and install Docker Desktop for Windows by visiting the site `https://hub.docker.com/explore`
    - Additional dependencies based on your OS
        - I'm on windows so needed WSL2 and that was all really.
    - How to confirm Docker is installed and your system can successfully run containers
        - Open a terminal and run `docker --version`
2. Manually Setting up a Container
    - How to run a container to test the Angular application
        - Run a command such as: `docker run -it --name angular-app -p 4200:4200 node:18-bullseye bash`
        - Explanation of Flags/Arguments:
            - -it: Runs the container in interactive mode with a terminal attached.
            - --name angular-app: Names the container “angular-app” for easier management.
            - -p 4200:4200: Maps port 4200 on your host to port 4200 in the container so the Angular app is accessible externally.
            - node:18-bullseye: Uses the official Node image appropriate for running Angular.
            - bash: Opens a bash shell in the container so you can run additional commands interactively.
    - Commands needed internal to the container to get additional dependencies
        - `npm install -g @angular/cli` `cd wsu-hw-ng-main` `npm install`
    - Commands needed internal to the container to run the application
        - 
    - How to verify that the container is successfully serving the Angular application
      - validate from container side
      - validate from host side
3. `Dockerfile` & Building Images
    - Summary / explanation of instructions written in the `Dockerfile`
    - How to build an image from the repository `Dockerfile`
    - How to run a container that will serve the Angular application from the image built by the `Dockerfile`
    - How to verify that the container is successfully serving the Angular application
      - validate from container side
      - validate from host side
5. Working with your DockerHub Repository
    - How to create a public repo in DockerHub
    - How to create a PAT for authentication (note recommended scope for this task)
      - **DO NOT** add your DockerHub PAT to your documentation 
    - How to authenticate with DockerHub via CLI using DockerHub credentials
      - **DO NOT** add your DockerHub PAT to your documentation 
    - How to push container image to your DockerHub repository
    - https://hub.docker.com/r/bwhittaker34/whittaker-ceg3120

## Part 2:

1. Configuring GitHub Repository Secrets:
    - How to create a PAT for authentication (note recommended scope for this task)
    - How to set repository Secrets for use by GitHub Actions
    - Describe the Secrets set for this project
2. CI with GitHub Actions
    - Summary of what your workflow does and when it does it
    - Explanation of workflow steps
    - Explanation / highlight of values that need updated if used in a different repository
      - changes in workflow
      - changes in repository
    - **Link** to workflow file in your GitHub repository
3. Testing & Validating
    - How to test that your workflow did its tasking
    - How to verify that the image in DockerHub works when a container is run using the image
