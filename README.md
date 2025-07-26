# pixidock_template

## Philosophy - Hermetic,  Reproducible, and Neat Python environment

This template shamelessly targets only 64 bit linux systems while favoring NVIDIA GPUs and Ubuntu. Sorry! PRs are welcome for support for other platforms ;p

Also, this template includes environments containing popular libraries for roboticists, as I am a roboticist, and I created this template largely for myself. However, it really could be used
for any Python project, especially if interfacing with the GPU. The robotics environments can easily be deleted; get rid of the envs/deps you don't need!
For those who like robots, there are environments for ROS 2, ROS 2 with GPU, [Genesis Simulator](https://genesis-world.readthedocs.io/en/latest/), and [NVIDIA Isaac Lab](https://isaac-sim.github.io/IsaacLab/main/index.html) (NVIDIA Isaac Simulator base physics engine with robot learning support overlay).
Check out the [pixi.toml](pixi.toml) to see all environments.

Pixi and Docker are two tools that together, in my opinion, can create a largely hermetic,  reproducible, and neat Python environment.
I think it's better than just ```pip``` and/or ```apt```  installing, or using ```venv```, or ```conda```, or ```mamba```, or other virtualization tools.
I will give [Bazel an honorable mention](https://github.com/RobotLocomotion/drake-ros/tree/main/bazel_ros2_rules/ros2#alternatives), but to be honest it seems harder to set up.
Of course, the environment isn't perfectly hermetic, reproducible, and neat, as some things love to be ```pip``` installed after Pixi environment creation.
Things that are pip installed after Pixi environment creation are not be reflected in the Pixi Lockfile (such as Isaac Lab, due the package platform being incorrectly identified as incompatible through Pixi-based uv PyPi installation, when pip doesn't fail on the platform check) and thus are weak points for reproducibility.

Although Pixi can create hermetic environments largely on its own, oftentimes a thin Docker virtualization layer may be needed to get CUDA to be reproducible across mistmatching host CUDA versions to be able to use the GPU (see an [example here](https://github.com/yuliangguo/depth_any_camera/pull/5))

I also like to use [Pixi with ROS 2 through the RoboStack project](https://robostack.github.io/GettingStarted.html#__tabbed_1_2), as this allows for using specific versions of PyTorch+CUDA with ROS 2 that may not be packaged with the ```apt``` repository ROS 2 package versions.

<details>
    <summary> Click to see more information about Pixi with ROS 2 through RoboStack </summary>

For example, a certain ROS 2 <code>apt</code> library named <code>library A</code> may be compiled against a specific <code>libtorch</code> version A when packaged in <code>apt</code>,
while an interesting third-party machine library named <code>library B</code> may depend on <code>libtorch</code> version B.
In this case, what some users may do, is try to just to globally <code>pip install torch==version B</code>. However, this can lead to an <code>undefined symbol</code> problem when trying to use both <code>library A</code> and <code>library B</code> together as  <code>library A</code> was compiled against <code>libtorch</code> version A.
Using RoboStack with ROS, allows to try to find a version of ```library A``` that depends on ```library B``` to avoid this sort of incompatibility issue.
It also increases reproducibility as well with versioned lockfiles for ROS packages.
<br>

In some cases, certain libraries may not be compatible out of the box with RoboStack.

In this case, there are two options that I like to do.

Option A: Building the library within a ROS workspace with RoboStack

The desired library may not be available on the RoboStack package index, but it maybe can still be built as part of the ROS workspace.
Run <code>pixi r build-ros</code> to build the [synchros2](https://github.com/bdaiinstitute/ros_utilities/wiki) package from source in <code>ros2_ws</code> directory to see an example.
However, [be wary of relying on rosdep](https://github.com/huggingface/lerobot).

Option B: Running the library within Docker with it's own standalone version of ROS 2, that communicates through ROS 2 with this template package

Some libraries, such as the Franka Robot Arm Drivers, can't yet be easily built with RoboStack (I failed on my attempt, but I know someone who succeded with careful version selection and building libfranka from source).
In this case, I would advise running these libraries
in their own standalone docker container, using the ```network=host``` flag when starting the container, with ROS 2 installed from ```apt``` or built from source.
This way, the library within the container should hopefully still be able to communicate with this template's ROS despite originating messages from two different versions of ROS 2.
Be wary of ```ufw``` blocking the UDP packets; see how to [enable multicast](https://docs.ros.org/en/rolling/How-To-Guides/Installation-Troubleshooting.html).

That being said, Option A and B may not cover every case. However, cases that can't be tackled with either of the above options, may not be possible to use with ROS even through other methods.

</details>
<br>

Finally, Pixi has [great multi-environment support](https://pixi.sh/dev/tutorials/multi_environment/).
For example, the same computer vision for robotics package can be used without ROS, with ROS, with a simulator, with a GPU, or combinations of the previous mentioned environments.

## Quick Start

### Usage as Template

```bash
git clone https://github.com/garylvov/pixidock_template <YOUR_PROJECT_NAME>
cd <YOUR_PROJECT_NAME>
bash scripts/name.bash <YOUR_PROJECT_NAME>
```

Then, delete everything above Quick Start, this line, and edit the rest of the README.
Feel free to open issues on the template GitHub page.
Set a license if applicable and delete that section from this README.
Good luck!


### Clone the Repo and Install Dependencies

This repository primarily targets x64 Linux.

```bash
git clone <YOUR_REPO_LINK>
cd TEMPLATE && git submodule update --init --recursive
```

Using Pixi directly to resolve dependencies is sometimes sufficient if the system is compatible
(Linux with correct drivers+version for GPU work).

Docker can be used to address GPU driver version mismatches through virtualization, while autoinstalling all dependencies.
This approach ensures the environment matches the project requirements exactly if possible.
For NVIDIA GPU setup with Docker, refer to [this guide](https://github.com/garylvov/dev_env/tree/main/setup_scripts/nvidia).
For non-GPU setup, install Docker and Docker compose, and follow the post-installation steps to ensure that Docker can be run without sudo.

If not using Docker, install Pixi on the base system with the following command.

```bash
curl -fsSL https://pixi.sh/install.sh | bash
```

### Environment Entry and Configuration

Optionally, to enter the Docker virtualization environment if desired to achieve CUDA version compatibility, run the following.

```bash
# Build and enter the container (GPU version by default)
bash scripts/develop.bash

# For CPU-only version
bash scripts/develop.bash --cpu

# You can also specify other options:
# bash scripts/develop.bash --base-image ubuntu:22.04 --image-name myproject --tag v1.0 --build-arg SOME_ARG=VALUE

# For a new terminal, docker container ls ; docker exec -it <CONTAINER_ID> -- bash
```

Then, from within either the project parent folder or the Docker image home directory, run the following
to activate the environment.

```bash
pixi s  # Activate environment, add -e for specific env,
# Envs: gpu|ros2-gpu|ros2-cpu|genesis-gpu|genesis-ros2-gpu|isaaclab

# For ROS, run "colcon build" or "pixi r build-ros" to build the ros2_ws
# colcon build is auto-configured by ros2_ws/colcon-defaults.yaml

# For Isaac Lab, do "pixi r install-isaaclab" to install all deps
```

### Run Commands

Here is where to put the entrypoints your user may care about.

## Testing and Linting

```bash
pixi run test  # Run with test environment
pixi run lint
```

## Changing License

1. Update `LICENSE.txt` file with your new license
3. Run: `pixi run lint`.

## Acknowledgement

This repository was created from the [pixidock_template created by Gary Lvov](https://github.com/garylvov/pixidock_template), under fair use of the BSD 1-Clause License
