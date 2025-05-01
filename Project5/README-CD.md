# Project Overview



## Some quick links

[README-CI](../Project4/READEME-CI.md)
[angular-site](../Project4/angular-site)
[Dockerfile](../Project4/Dockerfile)
[workflows](../.github/workflows)
[deployment](../deployment)

## Part 1

1. Generating `tag`s 
    - How to see tags in a `git` repository
        - Use git tag after cloning the repository to list all current tags.
    - How to generate a `tag` in a `git` repository
        - An exmaple is: `git tag -a v1.2.3 -m "Release version 1.2.3"`.
    - How to push a tag in a `git` repository to GitHub
        - To push a tag to GitHub, run `git push origin v1.2.3` or you could push all tags with `git push --tags`.
2. Semantic Versioning Container Images with GitHub Actions
    - Summary of what your workflow does and when it does it
        - The GitHub Actions workflow is triggered when a new semantic version tag (formatted as v*.*.*) is pushed. It performs the following steps:
            - Checks out the repository.
            - Sets up Docker Buildx.
            - Authenticates with DockerHub using repository secrets.
            - Uses the docker/metadata-action to compute image tags (latest, major, and major.minor).
            - Builds the Docker image and pushes it to DockerHub with the generated tags.
    - Explanation of workflow steps
        - Trigger: The workflow is exclusively triggered by new Git tags.
        - Docker Metadata Generation: The docker/metadata-action derives the necessary tags based on the pushed tag.
        - Push Process: The docker/build-push-action builds the image and pushes it to DockerHub.
    - Explanation / highlight of values that need updated if used in a different repository
        - changes in workflow/repository
            - Any naming conventions or file pathing.
    - **Link** to workflow file in your GitHub repository
        - [tag-build](../.github/workflows/tag-build.yml)
3. Testing & Validating
    - How to test that your workflow did its tasking
        - After pushing a new tag, check your repository’s Actions tab to see the build workflow in progress.
        - Validate that the logs indicate a successful login to DockerHub, metadata extraction, and image build.
    - How to verify that the image in DockerHub works when a container is run using the image
        - Log in to your DockerHub repository. You should see the new image available under these three tags: latest, the major version, and the major.minor version.

## Part 2

1. EC2 Instance Details
    - AMI information
        - Ubuntu Server 22.04 LTS.
    - Instance type 
        - t2.medium (2 CPU cores, 4 GB RAM).
    - Recommended volume size
        - 30 GB
    - Security Group configuration
        - 22: SSH – to log in remotely.
        - 80: HTTP – for the deployed Angular application.
        - 9000: For the webhook listener.
    - Security Group configuration justification / explanation
        - Opening port 22 allows secure administrative access.
        - Port 80 enables external access to our web application.
        - Port 9000 is dedicated to webhook payloads ensuring that only authorized requests trigger a deployment.
2. Docker Setup on OS on the EC2 instance
    - How to install Docker for OS on the EC2 instance
        - `sudo apt-get update`
        - `sudo apt-get install -y docker.io`
        - `sudo systemctl start docker`
        - `sudo systemctl enable docker`
        - `sudo usermod -aG docker ubuntu` 
    - Additional dependencies based on OS on the EC2 instance
        - For Ubuntu, Docker comes with everything needed.
    - How to confirm Docker is installed and that OS on the EC2 instance can successfully run containers
        - Run the following command to ensure Docker is properly installed: `docker run hello-world`
3. Testing on EC2 Instance
    - How to pull container image from DockerHub repository
        - `docker pull bwhittaker34/whittaker-ceg3120:latest`
    - How to run container from image 
        - `docker run -it --name test_app bwhittaker34/whittaker-ceg3120:latest`: Useful for debugging and real-time interaction.
        - `docker run -d --name live_app -p 80:80 bwhittaker34/whittaker-ceg3120:latest`: Recommended for production deployments where the container runs in the background.
    - How to verify that the container is successfully serving the Angular application
        - validate from container side
            - Use `docker logs live_app` to check that the app is running as expected.
        - validate from host side
            - `docker ps`
        - validate from an external connection (your physical system)
            - Open a browser or use `curl` on your physical system and navigate to http://<EC2-PUBLIC-IP>:80
    - Steps to manually refresh the container application if a new image is available on DockerHub
        - Stop and remove the container: `docker stop live_app && docker rm live_app`
        - Pull the latest image: `docker pull bwhittaker34/whittaker-ceg3120:latest`
        - Run a new container: `docker run -d --name live_app -p 80:80 bwhittaker34/whittaker-ceg3120:latest`
4. Scripting Container Application Refresh
    - How to test that the script successfully performs its taskings
        - Give the script execute permission: `chmod +x deploy.sh`
        - Run the script manually on the EC2 instance: `./deploy.sh`
        - Verify that the container is stopped (if previously running), refreshed with the new image, and running properly.
    - **LINK to bash script** in repository
        - [deployment/deploy.sh](../deployment/deploy.sh)
5. Configuring a `webhook` Listener on EC2 Instance
    - How to install [adnanh's `webhook`](https://github.com/adnanh/webhook) to the EC2 instance
        - Download the appropriate release binary for Linux from adnanh/webhook releases and extract it. For example:
            - `wget https://github.com/adnanh/webhook/releases/download/2.8.0/webhook-linux-amd64.tar.gz`
            - `tar -xzvf webhook-linux-amd64.tar.gz`
            - `sudo mv webhook /usr/local/bin/`
    - How to verify successful installation
        - Run `webhook -version`
    - Summary of the `webhook` definition file
        - This file tells the webhook listener to execute the deployment script when it receives a payload containing the header X-Webhook-Secret with the matching secret value.
    - How to verify definition file was loaded by `webhook`
        - Run webhook in verbose mode and check the log output to confirm that hooks.json is loaded.
    - How to verify `webhook` is receiving payloads that trigger it
        - how to monitor logs from running `webhook`
            - Run `sudo journalctl -u webhook -f`
        - what to look for in `docker` process views
            - Verify that containers are being stopped/removed/created as expected.
    - **LINK to definition file** in repository
        - [deployment/hooks.json](../deployment/hooks.json)
6. Configuring a Payload Sender
    - Justification for selecting GitHub or DockerHub as the payload sender
        - GitHub: Sends a payload when a GitHub Action completes (ensuring your build is successful) and may offer more detailed trigger events.
    - How to enable your selection to send payloads to the EC2 `webhook` listener
        - In the repository’s settings, add a webhook with a payload URL such as: `http://<EC2-PUBLIC-IP>:9000/hooks/deploy`
        - Set the content type to application/json and add the header X-Webhook-Secret with your shared secret.
    - Explain what triggers will send a payload to the EC2 `webhook` listener
        - Triggers could include new tag pushes or successful CI/CD runs.
    - How to verify a successful payload delivery
        - Check the logs from your webhook service to ensure that payloads are received.
        - Use curl to simulate a payload as a test: `curl -X POST -H "X-Webhook-Secret: HonorBestPup" -d '{}' http://<EC2-PUBLIC-IP>:9000/hooks/deploy`
7. Configure a `webhook` Service on EC2 Instance 
    - Summary of `webhook` service file contents
        - This service file instructs systemd to start the webhook listener on boot, ensures it runs as the ubuntu user, and specifies the paths for both the webhook binary and hooks file.
    - How to `enable` and `start` the `webhook` service
        - Copy the service file to the system directory: `sudo cp /home/ubuntu/deployment/webhook.service /etc/systemd/system/`
        - Reload systemd: `sudo systemctl daemon-reload`
        - Start the webhook service: `sudo systemctl start webhook`
        - Enable the service to start on boot: `sudo systemctl enable webhook`
        - Confirm the service is active: `sudo systemctl status webhook`
    - How to verify `webhook` service is capturing payloads and triggering bash script
        - Once the service is running, monitor the logs (ex: using journalctl or checking Docker container status) to ensure that incoming payloads trigger the deployment script.
    - **LINK to service file** in repository
        - [deployment/webhook.service](../deployment/webhook.service)
