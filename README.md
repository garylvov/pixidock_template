# TEMPLATE

## Quick Start

### Usage as Template

```bash
git clone <your-repository-url> <YOUR_PROJECT_NAME>
cd <YOUR_PROJECT_NAME>
bash name.bash <YOUR_PROJECT_NAME>
```

Then, delete this step your repo is set up ;)


### Clone the Repo and Install Dependencies

```bash
git clone <YOUR_REPO_LINK>
cd TEMPLATE && git submodule init && git submodule update
```

Using Pixi directly to resolve dependencies is sometimes sufficient if the system is compatible
(Linux with correct drivers+version for GPU work).

Docker can be used to address GPU driver version mismatches through virtualization, while autoinstalling all dependencies.
This approach ensures the environment matches the project requirements exactly if possible.
For NVIDIA GPU setup with Docker, refer to [this guide](https://github.com/garylvov/dev_env/tree/main/setup_scripts/nvidia).

If not using Docker, install Pixi on the base system with the following command.

```bash
curl -fsSL https://pixi.sh/install.sh | bash
```

### Run Commands

To enter the Docker environment if desired, run the following
(Docker must already be installed on the system, and must be able to be used without ``sudo``: see post-installation steps).

```bash
# Build the container
bash build.bash

# Enter the container
bash develop.bash  # GPU version, add --cpu for CPU version

# For a new terminal, docker container ls ; docker exec -it <CONTAINER_ID> -- bash
```

Then, from within either the Docker container or the project parent folder with Pixi installed on the system, run the following
to activate the environment.

```bash
pixi s  # Activate environment, add -e for specific env
```

## Testing and Linting

```bash
pixi run test  # Run with test environment
pixi run lint
```

## Changing License

1. Update `LICENSE.txt` file with your new license
3. Run: `pixi run lint`.
