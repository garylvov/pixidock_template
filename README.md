# pixidock_template

[![Pre-commit](https://github.com/garylvov/pixidock_template/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/garylvov/pixidock_template/actions/workflows/pre-commit.yaml) [![Test](https://github.com/garylvov/pixidock_template/actions/workflows/test.yaml/badge.svg)](https://github.com/garylvov/pixidock_template/actions/workflows/test.yaml)

## Philosophy - Hermetic,  Reproducible, and Neat Python environment(s)

This template shamelessly targets only 64 bit linux systems while favoring NVIDIA GPUs and Ubuntu. Sorry! PRs are welcome for support for other platforms ;p

Also, this template includes environments containing popular libraries for roboticists, as I am a roboticist, and I created this template largely for myself. However, it really could be used
for any Python project, especially if interfacing with the GPU. The robotics environments can easily be deleted; get rid of the envs/deps you don't need!
For those who like robots, there are environments for [ROS 2](https://www.ros.org/), ROS 2 with GPU, [Genesis Simulator](https://genesis-world.readthedocs.io/en/latest/), and [NVIDIA Isaac Lab](https://isaac-sim.github.io/IsaacLab/main/index.html) (NVIDIA Isaac Simulator base physics engine with robot learning support overlay).
Check out the [pixi.toml](pixi.toml) to see all environments.

Pixi and Docker are two tools that together, in my opinion, can create a largely hermetic,  reproducible, and neat Python environment.
I think it's better than just ```pip``` and/or ```apt```  installing, or using ```virtualenv```, or [uv alone](https://docs.astral.sh/uv/#installation), ```conda```, or ```mamba```, or other virtualization tools.
I will give [Bazel an honorable mention](https://github.com/RobotLocomotion/drake-ros/tree/main/bazel_ros2_rules/ros2#alternatives), but to be honest it seems harder to set up.
Of course, not all included environments are perfectly hermetic, reproducible, and neat, as some things [(such as Isaac Lab) need to be ```pip``` installed or otherwise configured after Pixi environment creation](scripts/install-isaaclab.bash) resulting in some instability as dependencies are sometimes omitted from the [Lockfile](pixi.lock). That being said, it is the closest I've gotten to hermetic, reproducible, and neat for many of the environments.

Although Pixi can create hermetic environments largely on its own, oftentimes a thin Docker virtualization layer may be needed to get CUDA to be reproducible across mismatching host CUDA versions to be able to use the GPU (see an [example here](https://github.com/yuliangguo/depth_any_camera/pull/5))

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

Some libraries, such as the Franka Robot Arm Drivers, can't yet be easily built with RoboStack (I failed on my attempt, but I know someone who succeeded with careful version selection and building libfranka from source).
In this case, I would advise running these libraries
in their own standalone docker container, using the ```network=host``` flag when starting the container, with ROS 2 installed from ```apt``` or built from source.
This way, the library within the container should hopefully still be able to communicate with this template's ROS despite originating messages from two different versions of ROS 2.
Be wary of ```ufw``` blocking the UDP packets; see how to [enable multicast](https://docs.ros.org/en/rolling/How-To-Guides/Installation-Troubleshooting.html).

That being said, Option A and B may not cover every case. However, cases that can't be tackled with either of the above options, may not be possible to use with ROS even through other methods.

</details>
<br>

Finally, Pixi has [great multi-environment support](https://pixi.sh/dev/tutorials/multi_environment/).
For example, the same computer vision for robotics package code can be used without ROS, with ROS, with a simulator, with a GPU, or combinations of the previous mentioned environments,
all [while sharing the same PyTorch version](pixi.toml) as a dependency.

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

This repository primarily targets x86-64 Linux.

```bash
git clone <YOUR_REPO_LINK>
cd TEMPLATE && git submodule update --init --recursive
```

[Pixi](https://pixi.sh/latest/) is all that's needed to locally to resolve dependencies if:
- Using CPU only environments on x86-64 Linux
- Using GPU compatible environments while having a matching CUDA version installed on the x86-64 Linux host system (CUDA ver. 12.6)

Otherwise, Docker (and Docker Compose) can be used to address GPU driver version mismatches through virtualization, while autoinstalling all dependencies.
This approach ensures the environment matches the project requirements exactly if possible.
To configure an NVIDIA GPU system with Docker/Docker Compose, refer to [this guide](https://github.com/garylvov/dev_env/tree/main/setup_scripts/nvidia).

Installing dependencies through Pixi locally WITHOUT Docker is highly recommended.

To use Pixi locally on the base system run the following installation command.

```bash
curl -fsSL https://pixi.sh/install.sh | bash
```

If using Docker, install [Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) and [Docker Compose](https://docs.docker.com/compose/install/linux/#install-using-the-repository) on the host system, and enter the container prior to running any commands with the following.

```bash
# Build and enter the container
bash scripts/develop-compose.bash
# For a new terminal, run "docker exec -it TEMPLATE_dev bash"
# To stop, run "docker compose down && sudo xhost -"
```

### Environment Entry and Configuration


Then, from within either the project parent folder or the Docker image home directory, run the following
to activate the environment(s).

```bash
pixi s  # Activate environment, add -e for specific env,
# Envs: gpu|ros2-gpu|ros2-cpu|genesis-gpu|genesis-ros2-gpu|isaaclab

# For ROS, run "colcon build" or "pixi r build-ros" to build the ros2_ws
# colcon build is auto-configured by ros2_ws/colcon-defaults.yaml
# To build your package, clone it into ros2_ws/src, and add its name to the colcon-defaults.yaml

# For Isaac Lab, do "pixi r install-isaaclab" to install all deps

# Genesis + Isaac Lab environments are still a bit flaky despite my best efforts ;(
```

### Run Commands

All run commands must occur from within the project parent folder or Docker image home directory to function correctly.

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
