# Part 1

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
    - Explanation / highlight of values that need updated if used in a different repository
    - changes in workflow
    - changes in repository
    - **Link** to workflow file in your GitHub repository
        - `.github/workflows/tag-build.yml`
3. Testing & Validating
    - How to test that your workflow did its tasking
    - How to verify that the image in DockerHub works when a container is run using the image
