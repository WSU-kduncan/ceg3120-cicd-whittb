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
        - `.github/workflows/tag-build.yml`
3. Testing & Validating
    - How to test that your workflow did its tasking
        - After pushing a new tag, check your repository’s Actions tab to see the build workflow in progress.
        - Validate that the logs indicate a successful login to DockerHub, metadata extraction, and image build.
    - How to verify that the image in DockerHub works when a container is run using the image
        - Log in to your DockerHub repository. You should see the new image available under these three tags: latest, the major version, and the major.minor version.

## Part 2

