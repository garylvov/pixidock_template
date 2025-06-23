# TEMPLATE

## Quick Start

### 0. Usage as Template

```bash
git clone <your-repository-url> <YOUR_PROJECT_NAME>
cd <YOUR_PROJECT_NAME>
bash name.bash <YOUR_PROJECT_NAME>
```

Then, delete step 0 after your repo is set  ;)


### 1: Clone the Repo and Install Dependencies

```bash
git clone <YOUR_REPO_LINK>
cd TEMPLATE && git submodule init && git submodule update
```

For dependencies, using **Pixi** directly is sometimes sufficient if the system is compatible
(Linux with correct drivers+version for GPU work).

Docker can be used to address GPU driver version mismatches through virtualization, while autoinstalling all dependencies.
This approach ensures the environment matches the project requirements exactly if possible.
For NVIDIA GPU setup with Docker, see [this guide](https://github.com/garylvov/dev_env/tree/main/setup_scripts/nvidia).

If not using Docker, install Pixi on the base system with the following command.

```bash
curl -fsSL https://pixi.sh/install.sh | bash
```

### 3. Run Commands

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

## Customization

### Setting Up License

1. **Edit the license files:**
   - Update `LICENSE` file with your chosen license
   - Update `.license-header.txt` with your license header

2. **Apply license headers to all files:**
   ```bash
   pixi run pre-commit run --all-files
   ```

3. **Review and commit:**
   ```bash
   git diff
   git add . && git commit -m 'Add license headers'
   ```

### Changing License

1. Update `LICENSE` file with your new license
2. Update `.license-header.txt` with your license header
3. Run: `pixi run pre-commit run --all-files`
