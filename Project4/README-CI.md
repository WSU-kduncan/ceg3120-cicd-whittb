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
        - `npm install -g @angular/cli`, `cd wsu-hw-ng-main`, `npm install`
    - Commands needed internal to the container to run the application
        - `ng serve --host 0.0.0.0`
    - How to verify that the container is successfully serving the Angular application
        - From the Container Side: Look at the logs (inside the container, you should see messages like “Compiled successfully” or “Angular Live Development Server is listening on 0.0.0.0:4200”).
        - Open a web browser and visit `http://localhost:4200`
3. `Dockerfile` & Building Images
    - Summary / explanation of instructions written in the `Dockerfile`
        - FROM node:18-bullseye: Starts with a Node.js base image.
        - RUN npm install -g @angular/cli: Installs the Angular CLI globally.
        - WORKDIR /app: Sets the working directory inside the container.
        - COPY [path] .: Copies your Angular project files (for example, from Project4/angular-site/wsu-hw-ng-main/ or angular-bird/wsu-hw-ng-main/ depending on your structure) into the container.
        - RUN npm install: Installs the necessary project dependencies.
        - EXPOSE 4200: (Optional) Informs Docker that the container listens on port 4200.
        - CMD ["ng", "serve", "--host", "0.0.0.0"]: Defines the default command to run the Angular development server.
    - How to build an image from the repository `Dockerfile`
        - From the directory containing your Dockerfile, run: `docker build -t my-angular-app .`
    - How to run a container that will serve the Angular application from the image built by the `Dockerfile`
        - To run a container based on your built image: `docker run -it --name angular-app -p 4200:4200 my-angular-app`
    - How to verify that the container is successfully serving the Angular application
        - Check logs by running: `docker logs angular-app`
        - Open a web browser and go to: `http://localhost:4200`
5. Working with your DockerHub Repository
    - How to create a public repo in DockerHub
        - Log in to Docker Hub, click on “Create Repository”, enter a repository name (e.g., whittaker-ceg3120) and ensure that you select “Public”, then complete the process to create the repository.
    - How to create a PAT for authentication (note recommended scope for this task)
        - Navigate to your Docker Hub account settings and look for Security.
        - Click New Access Token and name it appropriately (e.g., “GitHub Actions Token”).
        - Recommended Permissions/Scope: The token should have at least read and write access to repositories so that it can push (and optionally pull) images. Do not add extra scopes beyond what is needed.
    - How to authenticate with DockerHub via CLI using DockerHub credentials
        - `docker -u login username`, then it will prompt for a password or PAT
    - How to push container image to your DockerHub repository
        - Tag the Local Image: Assuming your local image is called my-angular-app, tag it with your Docker Hub repository name: `docker tag my-angular-app username/whittaker-ceg3120:latest`
        - Push the Image: Then push the image with: `docker push username/whittaker-ceg3120:latest`
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

## Resources:
- [Lucid Charts](https://www.lucidchart.com/pages/)
