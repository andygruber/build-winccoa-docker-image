# Documentation for "build-winccoa-docker-image" Repository

This repository hosts a GitHub Action workflow for
- downloading the current WinCC OA version from winccoa.com and
- generating and uploading Docker images of WinCC OA.

The workflow is defined in `.github\workflows\generate-winccoa-image.yml`.

## Setting Up

### Create environment
By default, for all workflow runs, an environment with the name `staging` is used.

Create all required environments and adapt the logic in the workflow (`get_environment -> env_check`) if you want to use multiple environments.

### Required Secrets
- `ETM_USERNAME`: Username for winccoa.com
- `ETM_PASSWORD`: Password for winccoa.com
- `DOCKER_USER`: DockerHub username
- `DOCKER_PASSWORD`: DockerHub password

### Required environment variables
- `DOCKER_IMAGE`: Name of the Docker image, e.g. `mydockerhubuser/winccoa`

### Triggering the Workflow
The workflow is triggered on:
- Push to `main`, `release/*`, `develop`, and `develop/*` branches.
- Published releases.

## Workflow Overview

### Get Environment
- **Environment Setup**: Gets the desired environment

### Preparation
- **Download Current WinCC OA Version**: Requires ETM_USERNAME and ETM_PASSWORD secrets for authentication​​
- **Extract Version Information**: Processes a ZIP filename to determine the WinCC OA version​​
- **Prepare Data for Docker Image Build**: Involves unzipping data and preparing it for Docker build​​.

### Docker Image Generation
- **Docker Setup**: Sets up Docker and builds a temporary image
- **Docker Build and Push Images**: Builds and pushes Docker images for different targets
- **Docker Build Teardown**: Tears down the Docker setup post-build​​

## Dockerfile Targets and Tags
The `build-docker/Dockerfile_install` includes targets like `api`, `server`, and `uiserver` with the prefix `winccoa`. Each target corresponds to a possible tag of the resulting Docker image.

The really built targets are defined in the step `Docker build and push images`.

### Modify or Add New Targets

1. **Adapt Dockerfile**: Define a new target in `build-docker/Dockerfile_install` in the form of `FROM <base> as winccoa<targetname>` or modify an existing one
2. **Edit Workflow File**: In the `.github/workflows` directory, open the workflow file `generate-winccoa-image.yml`
3. **Add/Modify Steps**:
   - Under the `Docker build and push images` step, modify the list of targets in the for loop include your new target or modify the existing one.
   - The default list defines the targets: `api server uiserver`

### Testing Your Changes
- It is highly recommended testing changes locally if possible, all docker commands can be run locally as well
- Once changes are verified locally, test the changes by triggering the workflow
- Monitor the build process to ensure your changes are correctly built and pushed

## Example
Given:
- Docker image base name: `mydockerhubuser/winccoa`
- Downloaded WinCC OA filename `WinCC_OA_3.19_linux_debian_x86_64_P007.zip`
- Extracted version: `3.19.7`
- List of targets: `api server uiserver`

Resulting Docker image names:
- `mydockerhubuser/winccoa:v3.19.7-api` from target `winccoaapi`
- `mydockerhubuser/winccoa:v3.19.7-server` from target `winccoaserver`
- `mydockerhubuser/winccoa:v3.19.7-uiserver` from target `winccoauiserver`

These images are built and pushed to DockerHub using the provided credentials.

## Contributing

Your contributions play a pivotal role in enhancing the open-source community, making it a hub for learning, inspiration, and innovation. Every contribution, big or small, is deeply appreciated.

**Steps to Contribute**:
1. Fork the Project.
2. Create your Feature Branch: `git checkout -b feature/YourFeatureName`.
3. Commit your Changes: `git commit -m 'Describe your change'`.
4. Push to the Branch: `git push origin feature/YourFeatureName`.
5. Open a Pull Request.

For suggestions or enhancements, either submit a pull request or open an issue with the "enhancement" tag. If you find value in this project, kindly star it. Your support means a lot to me!
