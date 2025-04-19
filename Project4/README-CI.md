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
        - Tag the Local Image: Assuming your local image is called my-angular-app, tag it with your Docker Hub repository name: `docker tag my-angular-app bwhittaker34/whittaker-ceg3120:latest`
        - Push the Image: Then push the image with: `docker push bwhittaker34/whittaker-ceg3120:latest`
    - https://hub.docker.com/r/bwhittaker34/whittaker-ceg3120

## Part 2:

1. Configuring GitHub Repository Secrets:
    - How to create a PAT for authentication (note recommended scope for this task)
        - Process: Log in to your Docker Hub account and navigate to Account Settings → Security. Click the New Access Token button.
        - Recommended Scope: Grant only the minimum necessary permissions—specifically, repository read and write access. This scope is sufficient for GitHub Actions to authenticate, push, and (if needed) pull images from your Docker Hub repository.
    - How to set repository Secrets for use by GitHub Actions
        - Open your GitHub repository in a web browser, go to Settings → Secrets and variables → Actions, and click on New repository secret for each secret you need.
    - Describe the Secrets set for this project
        - DOCKER_USERNAME: Contains your Docker Hub username
        - DOCKER_TOKEN: Contains the PAT you just created on Docker Hub
2. CI with GitHub Actions
    - Summary of what your workflow does and when it does it
        - Trigger: The workflow is configured to trigger on every push to the main branch.
        - Responsibilities: The workflow automatically:
            - Checks out the repository.
            - Sets up Docker Buildx to handle the build process.
            - Logs in to Docker Hub using the repository secrets.
            - Builds the Docker image from the repository (using your Dockerfile).
            - Tags and pushes the image to your Docker Hub repository
    - Explanation of workflow steps
        - Checkout Code: Uses actions/checkout@v3 to load the repository into the workflow environment.
        - Set Up Docker Buildx: Uses docker/setup-buildx-action@v2 to initialize Docker Buildx, which supports advanced build options and multi-platform builds.
        - Docker Hub Authentication: Uses docker/login-action@v2 to log in to Docker Hub. It uses the secrets DOCKER_USERNAME and DOCKER_TOKEN so no sensitive data is hard-coded.
        - Build and Push the Image: Uses docker/build-push-action@v4 with the current repository as the context. This step builds your image and then pushes it to your Docker Hub repository. The image is tagged (e.g., bwhittaker34/whittaker-ceg3120:latest).
    - Explanation / highlight of values that need updated if used in a different repository
        - changes in workflow
            - Image Tag: If your Docker Hub repository name or tag changes, update the tags field in the build-push action.
            - Context/Paths: If your repository structure (or the location of the Dockerfile) changes, update the context parameter accordingly.
        - changes in repository
            - Secrets: Ensure the secrets (DOCKER_USERNAME and DOCKER_TOKEN) are set in the new repository’s settings.
        - Workflow File Path: The workflow file is stored at ceg3120-cicd-whittb/.github/workflows/docker-image.yml
3. Testing & Validating
    - How to test that your workflow did its tasking
        - GitHub Actions Tab: After pushing a commit to the main branch, navigate to the Actions tab in your repository. Find the workflow run and:
        - Verify that all steps (checkout, Buildx setup, Docker Hub login, build, and push) complete without errors.
        - Look at the logs to ensure that the image was built correctly and that the push action succeeded.
        - Notification & Logs: GitHub will show a status indicator for the workflow run. You may also consider adding notifications (e.g., via email) if you wish to track build status automatically.
    - How to verify that the image in DockerHub works when a container is run using the image
        - Run the Image Locally: Pull and run the image from Docker Hub to test its functionality: `docker run -it --rm -p 4200:4200 bwhittaker34/whittaker-ceg3120:latest`
        - Inside the Container: Check container logs using: `docker logs <container_id_or_name>`
        - From the Host: Open a browser and go to http://localhost:4200. The application should load as expected.
        - DockerHub Repository: You can also log in to Docker Hub and inspect your repository to ensure the image appears with the correct tag after the workflow completes.

## Resources:
- [Lucid Charts](https://www.lucidchart.com/pages/)
